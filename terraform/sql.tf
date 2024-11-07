# Make PostgreSQL database
resource "google_sql_database_instance" "general" {
  name             = "${var.environment}-general"
  database_version = "POSTGRES_16"
  region           = "us-central1"

  settings {
    tier = "db-g1-small"

    ip_configuration {
      ipv4_enabled = true 
      
      authorized_networks {
        name  = google_compute_network.nogales-network.id
        value = "0.0.0.0/0"  
      }
    }
  }
}