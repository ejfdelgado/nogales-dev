locals {
  timestamp       = formatdate("YYMMDDhhmmss", timestamp())
  secrets         = jsondecode(file("../../nogales-secrets/${var.environment}.json"))
}
