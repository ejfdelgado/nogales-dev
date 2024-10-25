
resource "google_compute_network" "nogales-network" {
  project                 = var.project_name
  name                    = "${var.environment}-nogales-network"
  auto_create_subnetworks = false
  # Maximum Transmission Unit in bytes
  mtu = 1460
}

resource "google_compute_subnetwork" "nogales-subnetwork" {
  name = "${var.environment}-nogales-subnetwork"
  # 10.2.0.0 - 10.2.255.255
  ip_cidr_range = "10.2.0.0/28"
  region        = var.region
  network       = google_compute_network.nogales-network.id
}

resource "google_compute_firewall" "ssh-rule" {
  name    = "${var.environment}-nogales-ssh-rule"
  network = google_compute_network.nogales-network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http-rule" {
  name    = "${var.environment}-nogales-http-rule"
  network = google_compute_network.nogales-network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "https-rule" {
  name    = "${var.environment}-nogales-https-rule"
  network = google_compute_network.nogales-network.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "nogales_private_ip" {
  name         = "${var.environment}-nogales-private-ip"
  subnetwork   = google_compute_subnetwork.nogales-subnetwork.name
  address_type = "INTERNAL"
  region       = var.region
  address      = "10.2.0.4"
}

resource "google_vpc_access_connector" "connector" {
  name          = "${var.environment}-nogales-theconnector"
  region        = var.region
  max_instances = 3
  min_instances = 2
  subnet {
    name = google_compute_subnetwork.nogales-subnetwork.name
  }
}

resource "google_compute_address" "videcall_ip" {
  name   = "${var.environment}-nogales-videcall-ip"
  region = var.region
}