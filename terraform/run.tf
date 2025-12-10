
resource "google_cloud_run_v2_service" "assessment" {
  name     = "${var.environment}-assessment"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    containers {
      image = var.assessment_image
      env {
        name  = "LOGLEVEL"
        value = "error"
      }
      env {
        name  = "GOOGLE_APPLICATION_CREDENTIALS"
        value = var.credentials_path
      }
      env {
        name  = "USE_SECURE"
        value = "no"
      }
      env {
        name  = "ENV"
        value = "pro"
      }
      env {
        name  = "LOCAL_TRANSCRIPT"
        value = "yes"
      }
      env {
        name  = "TRAIN_SERVER"
        value = "NA"
      }
      env {
        name  = "FACE_SERVER"
        value = "N/A"
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
        name  = "WORKSPACE"
        value = "/tmp/app"
      }
      env {
        name  = "NODE_SERVER_PATH"
        value = "/"
        #value = "/assessment/"
      }
      env {
        name  = "POSTGRES_HOST"
        value = local.secrets.postgress.host
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

      resources {
        limits = {
          # 512Mi
          memory = "4Gi"
          # '1', '2', '4', and '8' 1000m 250m 500m
          cpu = "2"
        }
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
  # Allow unauthenticated invocations
  traffic {
    type            = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent         = 100
  }

  ingress = "INGRESS_TRAFFIC_ALL"  # Allows all traffic, including unauthenticated
  deletion_protection = false
}

resource "google_cloud_run_service_iam_member" "no_auth" {
  service     = google_cloud_run_v2_service.assessment.name
  location    = google_cloud_run_v2_service.assessment.location
  role        = "roles/run.invoker"
  member      = "allUsers"  # Allows all users to invoke the service
  depends_on = [google_cloud_run_v2_service.assessment]
}

/*
It works because on GoDaddy we have:
cname	test	ghs.googlehosted.com.
*/

resource "google_compute_managed_ssl_certificate" "assessment" {
  count = var.environment == "pro" ? 1 : 0
  name    = "${var.environment}-assessment-cert"
  managed {
    domains = ["test.solvista.me."]
  }
}
