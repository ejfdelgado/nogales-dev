resource "google_cloud_run_v2_service" "wordpress_1" {
  count    = var.environment == "pro" ? 1 : 0
  name     = "${var.environment}-common-backend"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    service_account = google_service_account.wordpress_1_sa.email
    containers {
      image = var.wordpress_image
      env {
        name  = "GOOGLE_CLIENT_ID"
        value = local.secrets.oauth_client_id
      }
      env {
        name  = "CORS_MAIN_ALLOWED_ORIGIN"
        value = "http://localhost:4200,https://localhost:4200"
      }
      env {
        name  = "BUCKET_NAME"
        value = google_storage_bucket.wordpress_1.name
      }
      env {
        name  = "LOCAL_FOLDER"
        value = "/var/www/html"
      }
      env {
        name  = "NODE_ENV"
        value = var.environment
      }

      resources {
        limits = {
          # 512Mi
          memory = "2Gi"
          # '1', '2', '4', and '8' 1000m 250m 500m
          cpu = "1"
        }
      }
      
      volume_mounts {
        name       = "gcs-volume"
        mount_path = "/var/www/html"
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    volumes {
      name = "gcs-volume"
      gcs {
        bucket    = google_storage_bucket.wordpress_1.name
        read_only = false
        #mount_options = [
        #  "implicit-dirs",
        #  "uid=1000",
        #  "gid=1000"
        #]
      }
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

resource "google_cloud_run_service_iam_member" "wordpress_1_no_auth" {
  count       = var.environment == "pro" ? 1 : 0
  service     = google_cloud_run_v2_service.wordpress_1[0].name
  location    = google_cloud_run_v2_service.wordpress_1[0].location
  role        = "roles/run.invoker"
  member      = "allUsers"
  depends_on = [google_cloud_run_v2_service.wordpress_1]
}

resource "google_service_account" "wordpress_1_sa" {
  account_id   = "${var.environment}-common-backend-sa"
  display_name = "Service account for Express backend"
}

resource "google_storage_bucket_iam_member" "wordpress_1_admin" {
  bucket = google_storage_bucket.wordpress_1.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.wordpress_1_sa.email}"
}

resource "google_storage_bucket_iam_member" "wordpress_1_object_admin" {
  bucket = google_storage_bucket.wordpress_1.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.wordpress_1_sa.email}"
}

resource "google_project_iam_member" "wordpress_1_logging" {
  project = var.project_name
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.wordpress_1_sa.email}"
}