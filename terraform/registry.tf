# us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/image-name

resource "google_artifact_registry_repository" "docker_repo" {
  count = var.environment == "pro" ? 1 : 0
  provider  = google
  location  = "us-central1"
  repository_id = "nogales"
  description   = "Docker repo in us-central1"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}