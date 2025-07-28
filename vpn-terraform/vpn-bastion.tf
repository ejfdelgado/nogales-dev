
resource "google_compute_instance" "bastion" {
  count        = 0
  name         = "${var.environment}-nogales-bastion"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  attached_disk {
    source      = google_compute_disk.stateful_disks[0].id
    device_name = "data-disk"
    mode        = "READ_WRITE"
  }

  network_interface {
    network = "default"

    access_config {

    }
  }

  metadata = {

  }

  tags = ["ssh"]
}
