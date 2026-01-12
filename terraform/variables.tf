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

variable "mysql_version" {
  description = "mysql_version"
  type        = string
  default     = "MYSQL_8_4"
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

variable "mysql_type" {
  description = "mysql_type"
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
  default     = "eyIzNzY5ZjM1YS0xYjcwLTRkZjEtYmU1Mi00YWQyNTdhMTkxNmUiOiJhcHBzX2FkbWluIiwiNGJiNzM5YjUtNzE0Ni00ZDU2LWI0N2QtMjU1ZGYzZjllMWIyIjoiYXBwc19kZXYiLCJhY2I5MDM1NC04YzA4LTQwNDgtOGRhYi04MjRkOTg4YzFmMmYiOiJhcHBzX2VkaXRvcnMiLCIwODg5MGViNy1jZDgyLTRmZTUtOWI0Ny00MjI1Y2Y0MGEwZjEiOiJhcHBzX2hpc3RvcmlhbnMiLCIyYzY2NzFjNC1iMjc0LTQ0YmQtYWU5Yi1mNTY0NzY3MWYzMWEiOiJhcHBzX2ltcG9ydGVyIiwiNDU4NzQzMzItN2NmNS00MDQ3LWJhNTctMmVjZDkxODNiN2ZjIjoiYXBwc192aWRlb2NhbGxfYWRtaW4iLCI3M2JjYjkyOS0wY2E2LTRiNTItOWVkZC00YWMzOWU2ZDZlOWUiOiJhcHBzX3ZpZGVvY2FsbF9wcm92aWRlciIsImQzMjVjNGI2LTFiYWItNDdhZi05N2M3LTlhYjJlMWUyNGZlZCI6ImFwcHNfdmlkZW9jYWxsX3N0YXRpc3RpY3MifQ=="
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

variable "videocall_disktype" {
  description = "videocall_disktype"
  type        = string
  default     = "2000"
}

variable "docker_image_speedmeter" {
  description = "docker_image_speedmeter"
  type        = string
}

variable "wordpress_image" {
  description = "Wordpress Image"
  type        = string
  default     = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:1.0.0"
}