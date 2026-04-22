resource "google_service_account" "videocall" {
  account_id   = "videocall-sa"
  display_name = "videocall Service Account"
}

resource "google_project_iam_member" "videocall_cloudsql_client" {
  project = var.project_name
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.videocall.email}"
}