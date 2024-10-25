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

variable "credentials_path" {
  description = "Credentials path"
  type        = string
  default     = ""
}

variable "sendgrid_apikey" {
  description = "sendgrid_apikey"
  type        = string
  default     = ""
}
