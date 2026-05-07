resource "google_cloud_run_v2_service" "vpn_config" {
  name     = "${var.environment}-nogales-vpn-config"
  location = var.region

  labels = {
    environment = var.environment
    application = "nogales"
    service     = "vpn-config"
    managed-by  = "terraform"
  }

  template {
    service_account = google_service_account.vpn_config.email

    containers {
      image = "gcr.io/cloudrun/placeholder"
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [
          google_sql_database_instance.general.connection_name,
        ]
      }
    }
  }

  lifecycle {
    ignore_changes = [template[0].containers]
  }

  depends_on = [
    google_service_account.vpn_config,
    google_project_iam_member.vpn_config_instance_sa_roles,
  ]
}

resource "google_storage_bucket_iam_member" "vpn_config_github_credentials_reader" {
  bucket = google_storage_bucket.github_credentials.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.vpn_config.email}"
}
