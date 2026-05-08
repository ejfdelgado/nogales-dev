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
      image = var.vpn_config_image
      env {
        name  = "ENV"
        value = "pro"
      }
      env {
        name  = "POSTGRES_HOST"
        #value = local.secrets.postgress.host
        value = "/cloudsql/${google_sql_database_instance.general.connection_name}"
      }
      env {
        name  = "POSTGRES_PORT"
        value = local.secrets.postgress.port
      }
      env {
        name  = "POSTGRES_DB"
        value = local.secrets.postgress.db
      }
      env {
        name  = "POSTGRES_USER"
        value = local.secrets.postgress.user
      }
      env {
        name  = "POSTGRES_PASSWORD"
        value = local.secrets.postgress.pass
      }
      env {
        name  = "CONFIG_BUCKET"
        value = "${var.environment}-nogales-github-credentials"
      }
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
