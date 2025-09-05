variable "project_name" {
  description = "Project name"
  type        = string
  default     = "local-volt-431316-m2"
}

variable "firebase_project_id" {
  description = "Firebase Project Id"
  type        = string
  default     = "local-volt-431316-m2"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "pro"
}

variable "location" {
  description = "Location"
  type        = string
  default     = "us-central"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone"
  type        = string
  default     = "us-central1-c"
}

variable "zonegpu" {
  description = "Zone"
  type        = string
  default     = "us-central1-a"
}

variable "email" {
  description = "Email"
  type        = string
  default     = "edgar.jose.fernando.delgado@gmail.com"
}

variable "assessment_image" {
  description = "Node Server Image"
  type        = string
  default     = ""
}

variable "videocall_image" {
  description = "Node Server Image"
  type        = string
  default     = ""
}

variable "turn_image" {
  description = "Turn Server Image"
  type        = string
  default     = ""
}

variable "credentials_path" {
  description = "Credentials path"
  type        = string
  default     = ""
}

variable "postgres_version" {
  description = "postgres_version"
  type        = string
  default     = "POSTGRES_16"
}

variable "email_gce_service_account" {
  description = "email_gce_service_account"
  type        = string
  default     = ""
}

variable "email_sender" {
  description = "email_sender"
  type        = string
  default     = "no_reply@nogalespsychological.com"
}

variable "sql_type" {
  description = "sql_type"
  type        = string
  default     = "db-g1-small"
}

variable "sql_gb" {
  description = "sql_gb"
  type        = string
  default     = "100"
}

variable "api_yml" {
  description = "api_yml"
  type        = string
  default     = "nogales_api.yaml"
}

variable "auth_group_id_map" {
  description = "auth_group_id_map"
  type        = string
  default     = "ewogICAgICAgICIzNzY5ZjM1YS0xYjcwLTRkZjEtYmU1Mi00YWQyNTdhMTkxNmUiOiAiYXBwc19hZG1pbiIsCiAgICAgICAgIjRiYjczOWI1LTcxNDYtNGQ1Ni1iNDdkLTI1NWRmM2Y5ZTFiMiI6ICJhcHBzX2RldiIsCiAgICAgICAgImFjYjkwMzU0LThjMDgtNDA0OC04ZGFiLTgyNGQ5ODhjMWYyZiI6ICJhcHBzX2VkaXRvcnMiLAogICAgICAgICIwODg5MGViNy1jZDgyLTRmZTUtOWI0Ny00MjI1Y2Y0MGEwZjEiOiAiYXBwc19oaXN0b3JpYW5zIiwKICAgICAgICAiMmM2NjcxYzQtYjI3NC00NGJkLWFlOWItZjU2NDc2NzFmMzFhIjogImFwcHNfaW1wb3J0ZXIiLAogICAgICAgICI0NTg3NDMzMi03Y2Y1LTQwNDctYmE1Ny0yZWNkOTE4M2I3ZmMiOiAiYXBwc192aWRlb2NhbGxfYWRtaW4iLAogICAgICAgICI3M2JjYjkyOS0wY2E2LTRiNTItOWVkZC00YWMzOWU2ZDZlOWUiOiAiYXBwc192aWRlb2NhbGxfcHJvdmlkZXIiCiAgICAgIH0="
}

variable "heymarket_end_point" {
  description = "heymarket_end_point"
  type        = string
  default     = ""
}

variable "webrtc_config" {
  description = "webrtc_config"
  type        = string
  default     = "./credentials/webrtcconfig.all.json"
}

variable "static_file_root" {
  description = "static_file_root"
  type        = string
  default     = "/home/ejfdelgado/desarrollo/nogales-dev/static-site"
}

variable "videocall_soup_ip" {
  description = "videocall_soup_ip"
  type        = string
}

variable "videocall_autorecovery" {
  description = "videocall_autorecovery"
  type        = string
  default     = "1"
}

variable "videocall_script" {
  description = "videocall_script"
  type        = string
  default = <<-EOT
    #!/bin/bash
    echo "Running default"
  EOT
}

variable "max_node_memory" {
  description = "max_node_memory"
  type        = string
  default     = "2000"
}

variable "soup_max_worker_load" {
  description = "soup_max_worker_load"
  type        = string
  default     = "5"
}