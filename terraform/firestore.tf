resource "google_firestore_database" "database" {
  project     = var.project_name
  name        = "${var.environment}-room-intro"
  # nam5 Estados Unidos, eur3 Europa
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"
}