# 1. Define the Cloud Tasks Queue
resource "google_cloud_tasks_queue" "client_creation" {
  name     = "${var.environment}-client-creation"
  location = google_cloud_run_v2_service.assessment.location

  rate_limits {
    # Limits the number of tasks dispatched per second
    max_dispatches_per_second = 10 
    
    # This is the key setting: only 1 task will run at any given moment
    max_concurrent_dispatches = 1 
  }

  retry_config {
    max_attempts       = 5
    min_backoff        = "10s"
    max_backoff        = "300s"
    max_doublings      = 2
  }

  depends_on = [google_cloud_run_v2_service.assessment]
}

