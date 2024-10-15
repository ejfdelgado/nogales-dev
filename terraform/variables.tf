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

# terraform apply -var environment="stg"
# terraform apply -var environment="pro"
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

variable "nodesrver_image" {
  description = "Node Server Image"
  type        = string
  default     = "us-docker.pkg.dev/ejfexperiments/us.gcr.io/nodeserver_front_back:1.4.0"
}

variable "credentials_path" {
  description = "Credentials path"
  type        = string
  default     = "/tmp/app/credentials/rosy-valor-429621-b6-841682b6208d.json"
}

variable "sendgrid_apikey" {
  description = "sendgrid_apikey"
  type        = string
  default     = "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"
}
