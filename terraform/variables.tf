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

variable "nginx_image" {
  description = "Nginx Image"
  type        = string
  default     = ""
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

variable "playground_image" {
  description = "Node Server Image"
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
  default     = "ewogICAgICAgICIzNzY5ZjM1YS0xYjcwLTRkZjEtYmU1Mi00YWQyNTdhMTkxNmUiOiAiYXBwc19hZG1pbiIsCiAgICAgICAgIjRiYjczOWI1LTcxNDYtNGQ1Ni1iNDdkLTI1NWRmM2Y5ZTFiMiI6ICJhcHBzX2RldiIsCiAgICAgICAgImFjYjkwMzU0LThjMDgtNDA0OC04ZGFiLTgyNGQ5ODhjMWYyZiI6ICJhcHBzX2VkaXRvcnMiLAogICAgICAgICIwODg5MGViNy1jZDgyLTRmZTUtOWI0Ny00MjI1Y2Y0MGEwZjEiOiAiYXBwc19oaXN0b3JpYW5zIiwKICAgICAgICAiNDU4NzQzMzItN2NmNS00MDQ3LWJhNTctMmVjZDkxODNiN2ZjIjogImFwcHNfdmlkZW9jYWxsX2FkbWluIiwKICAgICAgICAiNzNiY2I5MjktMGNhNi00YjUyLTllZGQtNGFjMzllNmQ2ZTllIjogImFwcHNfdmlkZW9jYWxsX3Byb3ZpZGVyIgogICAgICB9"
}

variable "heymarket_end_point" {
  description = "heymarket_end_point"
  type        = string
  default     = ""
}