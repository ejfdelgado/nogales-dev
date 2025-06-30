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
  name    = "${var.environment}-static-cert"
  managed {
    domains = ["apps.solvista.me"]
  }
}

resource "google_compute_backend_bucket" "static_backend" {
  name        = "${var.environment}-static-backend-bucket"
  bucket_name = google_storage_bucket.static_site.name
  enable_cdn  = true
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