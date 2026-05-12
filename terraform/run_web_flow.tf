resource "google_cloud_run_v2_service" "web_flow" {
  name     = "${var.environment}-nogales-web-flow"
  location = var.region

  deletion_protection = false

  scaling {
    min_instance_count = 0
  }

  labels = {
    environment = var.environment
    application = "nogales"
    service     = "${var.environment}-web-flow"
    managed-by  = "terraform"
  }

  template {
    service_account = google_service_account.vpn_config.email

    containers {
      image = var.web_flow_image
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
        name  = "CORS_MAIN_ALLOWED_ORIGIN"
        value = var.web_flow_cors
      }
      env {
        name  = "BUCKET_PUBLIC"
        value = "${var.environment}-nogales-public"
      }
      env {
        name  = "BUCKET_PRIVATE"
        value = "${var.environment}-nogales-private"
      }
      env {
        name  = "PROJECT_ID"
        value = var.project_name
      }
      env {
        name  = "PROJECT_NUMBER"
        value = data.google_project.project.number
      }
      env {
        name  = "PROJECT_REGION"
        value = var.region
      }
      env {
        name  = "SEND_GRID_VARIABLE"
        value = local.secrets.sendgrid_apikey
      }
      env {
        name  = "EMAIL_SENDER"
        value = var.email_sender
      }
      env {
        name  = "EMAIL_CONTACT_US"
        value = var.email_sender
      }
      env {
        name  = "MAILCHIMP_API_KEY"
        value = var.mailchimp_api_key
      }
      env {
        name  = "EMAIL_CONTACT_US"
        value = var.mailchimp_subscription_list
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
    google_service_account.web_flow,
    google_project_iam_member.web_flow_instance_sa_roles,
  ]
}

