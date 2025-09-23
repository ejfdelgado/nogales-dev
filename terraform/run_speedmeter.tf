resource "google_cloud_run_v2_service" "speedmeter" {
  name     = "${var.environment}-speedmeter"
  location = var.region

  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    containers {
      image = var.docker_image_speedmeter
      resources {
        limits = {
          memory = "2Gi"
          cpu    = "1"
        }
      }
      ports {
        container_port = 8080
      }
      env {
        name  = "ENV"
        value = "pro"
      }
    }
  }
}

# Allow unauthenticated access
resource "google_cloud_run_v2_service_iam_member" "speedmeter_public_access" {
  name     = google_cloud_run_v2_service.speedmeter.name
  location = google_cloud_run_v2_service.speedmeter.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
