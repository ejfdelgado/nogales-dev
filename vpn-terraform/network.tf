
resource "google_compute_network" "nogales-vpn-network" {
  name                    = "${var.environment}-nogales-vpn-network"
  project                 = var.project_name
  # Automatically create subnets
  auto_create_subnetworks = true
  # Maximum Transmission Unit in bytes
  # MTU tuning
  mtu = 1460
}

resource "google_compute_firewall" "vpn-ssh-rule" {
  name    = "${var.environment}-nogales-vpn-rules"
  network = google_compute_network.nogales-vpn-network.name
  allow {
    protocol = "tcp"
    ports    = ["4160"]
  }
  allow {
    protocol = "udp"
    ports    = ["500", "4500", "51820"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

