locals {
  timestamp       = formatdate("YYMMDDhhmmss", timestamp())
  secrets         = jsondecode(file("../../nogales-secrets/${var.environment}.json"))
  videocall_sa_roles = [
    "roles/artifactregistry.reader",       # pull docker images
    "roles/storage.objectViewer",          # devstorage.read_only
    "roles/logging.logWriter",             # logging.write
    "roles/monitoring.metricWriter",       # monitoring.write
    "roles/serviceusage.serviceUsageConsumer", # servicecontrol
    "roles/cloudtrace.agent",             # trace.append
    "roles/cloudsql.client",
  ]
  n8n_sa_roles = [
    "roles/artifactregistry.reader",       # pull docker images
    "roles/storage.objectViewer",          # devstorage.read_only
    "roles/logging.logWriter",             # logging.write
    "roles/monitoring.metricWriter",       # monitoring.write
    "roles/serviceusage.serviceUsageConsumer", # servicecontrol
    "roles/cloudtrace.agent",             # trace.append
    "roles/cloudsql.client",
  ]
}
