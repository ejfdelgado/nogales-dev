# Make PostgreSQL database
resource "google_sql_database_instance" "general" {
  name             = "${var.environment}-general"
  database_version = var.postgres_version
  region           = var.region

  settings {
    tier              = "db-g1-small"
    disk_size         = "100"

    ip_configuration {
      ipv4_enabled = true 
      
      authorized_networks {
        name  = google_compute_network.nogales-network.id
        value = "0.0.0.0/0"  
      }
    }
  }
}

/*
resource "google_sql_database_instance" "general_replica" {
  name             = "${var.environment}-general-replica"
  region           = var.region
  database_version = var.postgres_version
  master_instance_name = google_sql_database_instance.general.name

  depends_on = [google_sql_database_instance.general]

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = "db-g1-small"
    disk_size         = "100"

    ip_configuration {
      authorized_networks {
        name  = google_compute_network.nogales-network.id
        value = "0.0.0.0/0" 
      }
      ipv4_enabled = true
    }
  }

  deletion_protection = false
}
*/
