/*
resource "google_cloud_run_v2_service" "assessment" {
  name     = "${var.environment}-assessment"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  template {
    max_instance_request_concurrency = 20
    containers {
      image = var.nodesrver_image
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
        value = ""
      }
      env {
        name  = "WORKSPACE"
        value = "/tmp/app"
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
    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "ALL_TRAFFIC"
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
}
*/