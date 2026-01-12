resource "google_cloud_run_v2_service" "wordpress_1" {
  count    = var.environment == "pro" ? 1 : 0
  name     = "${var.environment}-wordpress-1"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    service_account = google_service_account.wordpress_1_sa[0].email
    containers {
      image = var.wordpress_image
      env {
        name  = "WORDPRESS_DB_HOST"
        value = google_sql_database_instance.wordpress_1[0].private_ip_address
      }
      env {
        name  = "WORDPRESS_DB_NAME"
        value = "wordpress"
      }
      env {
        name  = "WORDPRESS_DB_USER"
        value = local.secrets.mysql.user
      }
      env {
        name  = "WORDPRESS_DB_PASSWORD"
        value = local.secrets.mysql.pass
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
        mount_path = "/var/www/html/wp-content"
      }
    }
    vpc_access {
      connector = google_vpc_access_connector.wordpress_1a[0].id
      egress    = "PRIVATE_RANGES_ONLY"
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    volumes {
      name = "gcs-volume"
      gcs {
        bucket    = google_storage_bucket.wordpress_1[0].name
        read_only = false
      }
    }

    annotations = {
      "run.googleapis.com/volumes" = jsonencode([{
        name = "gcs-fuse-mount"
        gcs = {
          bucket    = google_storage_bucket.wordpress_1[0].name
          read_only = false
          mount_options = ["implicit-dirs", "allow-other"]
        }
      }])
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

# ----------------------------------------------------
# Service account

resource "google_service_account" "wordpress_1_sa" {
  count       = var.environment == "pro" ? 1 : 0
  account_id   = "${var.environment}-common-backend-sa"
  display_name = "Service account for Express backend"
}

resource "google_storage_bucket_iam_member" "wordpress_1_admin" {
  count       = var.environment == "pro" ? 1 : 0
  bucket = google_storage_bucket.wordpress_1[0].name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.wordpress_1_sa[0].email}"
}

resource "google_storage_bucket_iam_member" "wordpress_1_object_admin" {
  count       = var.environment == "pro" ? 1 : 0
  bucket = google_storage_bucket.wordpress_1[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.wordpress_1_sa[0].email}"
}

resource "google_project_iam_member" "wordpress_1_logging" {
  count       = var.environment == "pro" ? 1 : 0
  project = var.project_name
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.wordpress_1_sa[0].email}"
}