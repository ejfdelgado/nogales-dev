/*
resource "google_compute_network" "imagiation-network" {
  project                 = var.project_name
  name                    = "imagiation-network"
  auto_create_subnetworks = false
  # Maximum Transmission Unit in bytes
  mtu = 1460
}

resource "google_compute_subnetwork" "imagiation-subnetwork" {
  name = "imagiation-subnetwork"
  # 10.2.0.0 - 10.2.255.255
  ip_cidr_range = "10.2.0.0/28"
  region        = var.region
  network       = google_compute_network.imagiation-network.id
}

resource "google_compute_firewall" "ssh-rule" {
  name    = "ssh-rule"
  network = google_compute_network.imagiation-network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http-rule" {
  name    = "http-rule"
  network = google_compute_network.imagiation-network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "https-rule" {
  name    = "https-rule"
  network = google_compute_network.imagiation-network.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "nogales_private_ip" {
  name         = "nogales-private-ip"
  subnetwork   = google_compute_subnetwork.imagiation-subnetwork.name
  address_type = "INTERNAL"
  region       = var.region
  address      = "10.2.0.4"
}

resource "google_vpc_access_connector" "connector" {
  name   = "nogales-connector"
  region = var.region
  subnet {
    name = google_compute_subnetwork.imagiation-subnetwork.name
  }
}
*/

/*
resource "google_compute_address" "imagiation1ip" {
  count  = var.docker_image_job_image_training_count
  name   = "imagiation1ip"
  region = var.region
}

resource "google_compute_address" "imagiation2ip" {
  count  = var.docker_image_job_image_training_count
  name   = "imagiation2ip"
  region = var.region
}
*/

/*
resource "google_compute_address" "nogalesip" {
  name   = "nogalesip"
  region = var.region
}
*/
