locals {
  timestamp       = formatdate("YYMMDDhhmmss", timestamp())
  secrets         = jsondecode(file("../../nogales-secrets/${var.environment}.json"))
  vpn_sa_roles = [
    "roles/artifactregistry.reader",       # pull docker images
    "roles/logging.logWriter",             # logging.write
    "roles/monitoring.metricWriter",       # monitoring.write
    "roles/serviceusage.serviceUsageConsumer", # servicecontrol
    "roles/cloudtrace.agent",             # trace.append
  ]
}
