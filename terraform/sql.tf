# Make PostgreSQL database
resource "google_sql_database_instance" "general" {
  name             = "${var.environment}-general"
  database_version = var.postgres_version
  region           = var.region

  settings {
    tier              = var.sql_type
    disk_size         = var.sql_gb

    ip_configuration {
      ipv4_enabled = true 
      
      authorized_networks {
        name  = google_compute_network.nogales-network.id
        value = "0.0.0.0/0"  
      }
    }

    backup_configuration {
      enabled            = var.environment == "pro" ? true : false
      start_time         = "01:00"
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
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

resource "google_sql_database_instance" "wordpress_1" {
  count            = var.environment == "pro" ? 1 : 0
  name             = "${var.environment}-wordpress-1"
  database_version = var.mysql_version
  region           = var.region

  depends_on = [google_service_networking_connection.default]

  settings {
    tier              = var.mysql_type
    disk_size         = var.sql_gb

    ip_configuration {
      ipv4_enabled = true 
      
      authorized_networks {
        name  = "ejfdelgado"
        value = "45.173.12.238"  
      }

      private_network = google_compute_network.peering_network.id
    }

    backup_configuration {
      enabled            = var.environment == "pro" ? true : false
      start_time         = "01:00"
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
  }
}