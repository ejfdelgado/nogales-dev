
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
        name  = "CORS_MAIN_ALLOWED_ORIGIN"
        value = var.assessment_cors
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
        name  = "TASK_QUEUE_CREATE_CLIENT"
        value = "${var.environment}-client-creation"
      }
      env {
        name  = "CLOUD_RUN_CREATE_CLIENT_URL"
        value = "https://${var.environment}-assessment-${data.google_project.project.number}.${var.region}.run.app"
      }
      env {
        name  = "USE_QUEUE"
        value = "1"
      }
      env {
        name = "PASS_TO_ENCODE"
        value = local.secrets.link_key_pass
      }
      env {
        name = "DEFAULT_ASSESSMENT_USER_CREATOR"
        value = local.secrets.default_assessment_user_creator
      }
      env {
        name = "EMAIL_TARGET_DOMAIN"
        value = var.assessment_domain
      }
      
      resources {
        limits = {
          # 512Mi
          memory = "4Gi"
          # '1', '2', '4', and '8' 1000m 250m 500m
          cpu = "2"
        }
      }
      volume_mounts {
        mount_path = "/cloudsql"
        name       = "cloudsql"
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
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    service_account = google_service_account.assessment.email
  }
  # Allow unauthenticated invocations
  traffic {
    type            = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent         = 100
  }

  ingress = "INGRESS_TRAFFIC_ALL"  # Allows all traffic, including unauthenticated
  deletion_protection = false

  depends_on = [
    google_service_account.assessment,
    google_project_iam_member.assessment_instance_sa_roles,
  ]
}

# This defines who can call the cloud run
resource "google_cloud_run_v2_service_iam_member" "no_auth" {
  project  = google_cloud_run_v2_service.assessment.project
  location = google_cloud_run_v2_service.assessment.location
  name     = google_cloud_run_v2_service.assessment.name
  role     = "roles/run.invoker"
  member   = "allUsers"
  depends_on = [
    google_cloud_run_v2_service.assessment,
    google_service_account.assessment,
    google_project_iam_member.assessment_instance_sa_roles,
  ]
}

/*
It works because on GoDaddy we have:
cname	test	ghs.googlehosted.com.

and, on google cloud we use domain mapping:
https://console.cloud.google.com/run/domains?project=local-volt-431316-m2
*/

