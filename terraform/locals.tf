locals {
  timestamp       = formatdate("YYMMDDhhmmss", timestamp())
  secrets         = jsondecode(file("../../nogales-secrets/pro.json"))
}
