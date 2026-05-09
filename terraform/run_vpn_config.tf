resource "google_cloud_run_v2_service" "vpn_config" {
  name     = "${var.environment}-nogales-vpn-config"
  location = var.region

  deletion_protection = false

  scaling {
    min_instance_count = 0
  }

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
      volume_mounts {
        mount_path = "/cloudsql"
        name       = "cloudsql"
      }
      env {
        name  = "ENV"
        value = var.environment
      }
      env {
        name  = "AUTH_GROUP_ID_MAP"
        value = var.auth_group_id_map
      }
      env {
        name  = "AUTH_PROVIDER"
        value = local.secrets.authentication.AUTH_PROVIDER
      }
      env {
        name  = "MICROSOFT_CLIENT_ID"
        value = local.secrets.authentication.MICROSOFT_CLIENT_ID
      }
      env {
        name  = "MICROSOFT_TENANT"
        value = local.secrets.authentication.MICROSOFT_TENANT
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
      env {
        name  = "CORS_MAIN_ALLOWED_ORIGIN"
        value = var.vpn_config_cors
      }
      env {
        name  = "FIREBASE_SERVICE_ACCOUNT_PATH"
        # Yes, now use only stg, even for pro
        # because the docker image is built only on stg, not in pro.
        # pro just uses the docker image generated for stg.
        value = "./credentials/stg-token-auth.json"
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
