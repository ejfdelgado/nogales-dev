
resource "google_project_service" "artifact_registry" {
  service = "artifactregistry.googleapis.com"
}

# gcloud auth configure-docker us-central1-docker.pkg.dev

# us-docker.pkg.dev/ejfexperiments/us.gcr.io/nogales_videocall_front_back:1.18.1
# us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_videocall_front_back:1.18.1
# docker tag us-docker.pkg.dev/ejfexperiments/us.gcr.io/nogales_videocall_front_back:1.18.1 us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_videocall_front_back:1.18.1
# docker push us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_videocall_front_back:1.18.1 && npm run bip

# us-docker.pkg.dev/ejfexperiments/us.gcr.io/nogales_assessment_front_back:1.37.2
# us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_assessment_front_back:1.37.2
# docker tag us-docker.pkg.dev/ejfexperiments/us.gcr.io/nogales_assessment_front_back:1.37.2 us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_assessment_front_back:1.37.2
# docker push us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_assessment_front_back:1.37.2 && npm run bip

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