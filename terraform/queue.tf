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

# 2. Grant Cloud Tasks Permission to Invoke the Function
resource "google_cloud_run_v2_service_iam_member" "client_creation_assessment_caller" {
  project  = google_cloud_run_v2_service.assessment.project
  location = google_cloud_run_v2_service.assessment.location
  name     = google_cloud_run_v2_service.assessment.name
  role     = "roles/run.invoker"
  
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudtasks.iam.gserviceaccount.com"
}


# Grant the Development SA permission to "act as" service accounts in the project
resource "google_project_iam_member" "cloud_run_sa_can_use_task_queue" {
  project = var.project_name
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:development@${var.project_name}.iam.gserviceaccount.com"
}
