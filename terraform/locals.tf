locals {
  timestamp       = formatdate("YYMMDDhhmmss", timestamp())
  secrets         = jsondecode(file("../../nogales-secrets/pro.json"))
}

output "postgress_pass" {
    value = local.secrets.postgress_pass
}