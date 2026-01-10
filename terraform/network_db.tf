resource "google_compute_network" "peering_network" {
  name                    = "${var.environment}-peering-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_global_address" "wordpress_1" {
  name          = "${var.environment}-wordpress-1"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.peering_network.id
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.peering_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.wordpress_1.name]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  peering              = google_service_networking_connection.default.peering
  network              = google_compute_network.peering_network.name
  import_custom_routes = true
  export_custom_routes = true
}

# -----------------------------------

resource "google_compute_global_address" "wordpress_1a" {
  name          = "${var.environment}-wordpress-1a"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.nogales-network.id
}

resource "google_service_networking_connection" "default_a" {
  network                 = google_compute_network.nogales-network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.wordpress_1a.name]
}

resource "google_compute_network_peering_routes_config" "peering_routes_a" {
  peering              = google_service_networking_connection.default_a.peering
  network              = google_compute_network.nogales-network.name
  import_custom_routes = true
  export_custom_routes = true
}

resource "google_vpc_access_connector" "wordpress_1a" {
  name          = "${var.environment}-wordpress-1a"
  region        = var.region
  network       = google_compute_network.nogales-network.name
  ip_cidr_range = "10.8.0.0/28"
  min_instances = 2
  max_instances = 10
}