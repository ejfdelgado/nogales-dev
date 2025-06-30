resource "google_storage_bucket" "static_site" {
  name     = "${var.environment}-nogales-assets"
  location = "US"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "static_site_access" {
  bucket = google_storage_bucket.static_site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_compute_managed_ssl_certificate" "static_ssl" {
  name = "${var.environment}-static-cert"
  managed {
    domains = [
       var.environment == "pro" ? "apps.solvista.me" : "apps-stg.solvista.me"
    ]
  }
}

resource "google_compute_backend_bucket" "static_backend" {
  name        = "${var.environment}-static-backend-bucket"
  bucket_name = google_storage_bucket.static_site.name
  enable_cdn  = false

  cdn_policy {
    cache_mode                   = "CACHE_ALL_STATIC"
    default_ttl                  = 60 # 1 hour (in seconds)
    max_ttl                      = 60 # 1 day
    client_ttl                   = 60 # 5 minutes sent to browsers
    negative_caching             = true
    signed_url_cache_max_age_sec = 60
  }
}

resource "google_compute_url_map" "static_map" {
  name            = "${var.environment}-static-url-map"
  default_service = google_compute_backend_bucket.static_backend.id
}

resource "google_compute_target_https_proxy" "static_proxy" {
  name             = "${var.environment}-static-https-proxy"
  ssl_certificates = [google_compute_managed_ssl_certificate.static_ssl.id]
  url_map          = google_compute_url_map.static_map.id
}

resource "google_compute_global_address" "static_ip" {
  name = "${var.environment}-static-ip"
}

resource "google_compute_global_forwarding_rule" "https_rule" {
  name                  = "${var.environment}-static-https-forward"
  target                = google_compute_target_https_proxy.static_proxy.id
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.static_ip.address
}

variable "static_file_list" {
  type = map(string)
  default = {
    #"camera/index.html" = "camera/index.html",
    #"camera/js/index.js" = "camera/js/index.js",
    "404.html" = "404.html"
  }
}

resource "google_storage_bucket_object" "static_site" {
  for_each      = var.static_file_list
  name          = each.value
  source        = "${var.static_file_root}/${each.key}"
  bucket        = google_storage_bucket.static_site.id
  cache_control = "no-store, no-cache, must-revalidate, max-age=0"
}
