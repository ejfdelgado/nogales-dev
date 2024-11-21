# IP public address needed for turn
resource "google_compute_address" "turn_ip" {
  name   = "${var.environment}-nogales-turn-ip"
  region = var.region
}

resource "google_compute_firewall" "turn_ports" {
  name    = "${var.environment}-nogales-turn-firewall"
  network = google_compute_network.nogales-network.name

  // Define the source ranges (IP addresses allowed to connect)
  source_ranges = ["0.0.0.0/0"] # Replace with a specific IP range if needed for security.

  // Allow UDP and TCP traffic for TURN ports
  allow {
    protocol = "udp"
    ports    = ["3478", "49152-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["3478", "443"]
  }

  // Add tags to apply the rule to specific instances
  target_tags = ["turn-server"]
}

resource "google_compute_address" "nogales_private_turn_ip" {
  name         = "${var.environment}-nogales-private-turn-ip"
  subnetwork   = google_compute_subnetwork.nogales-subnetwork.name
  address_type = "INTERNAL"
  region       = var.region
  address      = "10.2.0.8"
}