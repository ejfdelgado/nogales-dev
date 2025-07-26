
resource "google_compute_disk" "stateful_disks" {
  count = 2
  name  = "${var.environment}-vpn-disk-${count.index}"
  type  = "pd-standard"
  zone  = var.zone
  size  = 5
}
