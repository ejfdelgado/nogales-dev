resource "google_artifact_registry_repository" "docker_repo" {
  provider  = google
  location  = "us-central1"
  repository_id = "nogales"
  description   = "Docker repo in us-central1"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}