
resource "google_compute_disk" "stateful_disks" {
  count = 1
  name  = "${var.environment}-vpn-disk-${count.index}"
  type  = "pd-standard"
  zone  = var.zone
  size  = 5
}

