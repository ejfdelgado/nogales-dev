resource "google_service_account" "videocall" {
  account_id   = "videocall-sa"
  display_name = "videocall Service Account"
}

resource "google_project_iam_member" "videocall_instance_sa_roles" {
  for_each = toset(local.videocall_sa_roles)

  project = var.project_name
  role    = each.value
  member  = "serviceAccount:${google_service_account.videocall.email}"
}