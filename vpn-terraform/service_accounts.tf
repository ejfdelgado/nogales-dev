# Video call

resource "google_service_account" "vpn" {
  account_id   = "${var.environment}-vpn-sa"
  display_name = "vpn Service Account"
}

resource "google_project_iam_member" "vpn_instance_sa_roles" {
  for_each = toset(local.vpn_sa_roles)

  project = var.project_name
  role    = each.value
  member  = "serviceAccount:${google_service_account.vpn.email}"
}