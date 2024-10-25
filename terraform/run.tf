
resource "google_cloud_run_v2_service" "assessment" {
  name     = "${var.environment}-assessment"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    containers {
      image = var.assessment_image
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
        name  = "TRAIN_SERVER"
        value = "NA"
      }
      env {
        name  = "FACE_SERVER"
        value = "NA"
      }
      env {
        name  = "SEND_GRID_VARIABLE"
        value = var.sendgrid_apikey
      }
      env {
        name  = "WORKSPACE"
        value = "/tmp/app"
      }
      env {
        name  = "NODE_SERVER_PATH"
        value = "/"
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
}

resource "google_cloud_run_service_iam_member" "no_auth" {
  service     = google_cloud_run_v2_service.assessment.name
  location    = google_cloud_run_v2_service.assessment.location
  role        = "roles/run.invoker"
  member      = "allUsers"  # Allows all users to invoke the service
  depends_on = [google_cloud_run_v2_service.assessment]
}

resource "google_cloud_run_v2_service" "videocall" {
  name     = "${var.environment}-videocall"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    containers {
      image = var.videocall_image
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
        name  = "TRAIN_SERVER"
        value = "NA"
      }
      env {
        name  = "FACE_SERVER"
        value = "NA"
      }
      env {
        name  = "SEND_GRID_VARIABLE"
        value = var.sendgrid_apikey
      }
      env {
        name  = "WORKSPACE"
        value = "/tmp/app"
      }
      env {
        name  = "NODE_SERVER_PATH"
        value = "/"
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
}

resource "google_cloud_run_service_iam_member" "no_auth_videocall" {
  service     = google_cloud_run_v2_service.videocall.name
  location    = google_cloud_run_v2_service.videocall.location
  role        = "roles/run.invoker"
  member      = "allUsers"  # Allows all users to invoke the service
  depends_on = [google_cloud_run_v2_service.videocall]
}