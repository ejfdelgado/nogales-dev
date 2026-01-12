
resource "google_compute_global_address" "wordpress_1a" {
  count    = var.environment == "pro" ? 1 : 0
  name          = "${var.environment}-wordpress-1a"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.nogales-network.id
}

resource "google_service_networking_connection" "default_a" {
  count    = var.environment == "pro" ? 1 : 0
  network                 = google_compute_network.nogales-network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.wordpress_1a[0].name]
}

resource "google_compute_network_peering_routes_config" "peering_routes_a" {
  count    = var.environment == "pro" ? 1 : 0
  peering              = google_service_networking_connection.default_a[0].peering
  network              = google_compute_network.nogales-network.name
  import_custom_routes = true
  export_custom_routes = true
}

resource "google_vpc_access_connector" "wordpress_1a" {
  count    = var.environment == "pro" ? 1 : 0
  name          = "${var.environment}-wordpress-1a"
  region        = var.region
  network       = google_compute_network.nogales-network.name
  ip_cidr_range = "10.8.0.0/28"
  min_instances = 2
  max_instances = 10
}