# Video call

resource "google_service_account" "videocall" {
  account_id   = "${var.environment}-videocall-sa"
  display_name = "videocall Service Account"
}

resource "google_project_iam_member" "videocall_instance_sa_roles" {
  for_each = toset(local.videocall_sa_roles)

  project = var.project_name
  role    = each.value
  member  = "serviceAccount:${google_service_account.videocall.email}"
}

# Assessment

resource "google_service_account" "assessment" {
  account_id   = "${var.environment}-assessment-sa"
  display_name = "Assessment Service Account"
}

resource "google_project_iam_member" "assessment_instance_sa_roles" {
  for_each = toset(local.assessment_sa_roles)

  project = var.project_name
  role    = each.value
  member  = "serviceAccount:${google_service_account.assessment.email}"
}

# n8n

resource "google_service_account" "n8n" {
  account_id   = "${var.environment}-n8n-sa"
  display_name = "n8n Service Account"
}

resource "google_project_iam_member" "n8n_instance_sa_roles" {
  for_each = toset(local.n8n_sa_roles)

  project = var.project_name
  role    = each.value
  member  = "serviceAccount:${google_service_account.n8n.email}"
}

# github

resource "google_service_account" "github" {
  account_id   = "${var.environment}-github-sa"
  display_name = "github Service Account"
}

resource "google_project_iam_member" "github_instance_sa_roles" {
  for_each = toset(local.github_sa_roles)

  project = var.project_name
  role    = each.value
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_storage_bucket_iam_member" "github_credentials_access" {
  bucket = google_storage_bucket.github_credentials.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.github.email}"
}