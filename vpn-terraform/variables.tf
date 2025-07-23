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

variable "vpn_image" {
  description = "vpn_image"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "zone" {
  description = "zone"
  type        = string
}