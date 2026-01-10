terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50.0" # Use version 4.50.0 or later
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.50.0"
    }
  }
}

provider "google" {
  project = var.project_name
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_name
  region  = var.region
}

# Enables the Cloud Run API
/*
resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = true
}
*/