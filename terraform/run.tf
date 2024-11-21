
resource "google_cloud_run_v2_service" "nginx" {
  name     = "${var.environment}-nginx"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    containers {
      image = var.nginx_image
      resources {
        limits = {
          # 512Mi
          memory = "4Gi"
          # '1', '2', '4', and '8' 1000m 250m 500m
          cpu = "2"
        }
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "ALL_TRAFFIC"
    }
  }
  # Allow unauthenticated invocations
  traffic {
    type            = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent         = 100
  }

  ingress = "INGRESS_TRAFFIC_ALL"  # Allows all traffic, including unauthenticated
  deletion_protection = false
}

resource "google_cloud_run_service_iam_member" "no_auth_nginx" {
  service     = google_cloud_run_v2_service.nginx.name
  location    = google_cloud_run_v2_service.nginx.location
  role        = "roles/run.invoker"
  member      = "allUsers"  # Allows all users to invoke the service
  depends_on = [google_cloud_run_v2_service.nginx]
}

resource "google_cloud_run_v2_service" "assessment" {
  name     = "${var.environment}-assessment"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    containers {
      image = var.assessment_image
      env {
        name  = "GOOGLE_APPLICATION_CREDENTIALS"
        value = var.credentials_path
      }
      env {
        name  = "USE_SECURE"
        value = "no"
      }
      env {
        name  = "ENV"
        value = "pro"
      }
      env {
        name  = "TRAIN_SERVER"
        value = "NA"
      }
      env {
        name  = "FACE_SERVER"
        value = "N/A"
      }
      env {
        name  = "SEND_GRID_VARIABLE"
        value = local.secrets.postgress_pass
      }
      env {
        name  = "WORKSPACE"
        value = "/tmp/app"
      }
      env {
        name  = "NODE_SERVER_PATH"
        value = "/"
        #value = "/assessment/"
      }
      env {
        name  = "POSTGRES_HOST"
        value = "35.239.160.163"
      }
      env {
        name  = "POSTGRES_PORT"
        value = "5432"
      }
      env {
        name  = "POSTGRES_DB"
        value = "nogales"
      }
      env {
        name  = "POSTGRES_USER"
        value = "postgres"
      }
      env {
        name  = "POSTGRES_PASSWORD"
        value = local.secrets.postgress_pass
      }
      resources {
        limits = {
          # 512Mi
          memory = "4Gi"
          # '1', '2', '4', and '8' 1000m 250m 500m
          cpu = "2"
        }
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
  # Allow unauthenticated invocations
  traffic {
    type            = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent         = 100
  }

  ingress = "INGRESS_TRAFFIC_ALL"  # Allows all traffic, including unauthenticated
  deletion_protection = false
}

resource "google_cloud_run_service_iam_member" "no_auth" {
  service     = google_cloud_run_v2_service.assessment.name
  location    = google_cloud_run_v2_service.assessment.location
  role        = "roles/run.invoker"
  member      = "allUsers"  # Allows all users to invoke the service
  depends_on = [google_cloud_run_v2_service.assessment]
}

resource "google_cloud_run_v2_service" "playground" {
  name     = "${var.environment}-playground"
  location = var.region
  template {
    max_instance_request_concurrency = 20
    containers {
      image = var.playground_image
      env {
        name  = "GOOGLE_APPLICATION_CREDENTIALS"
        value = var.credentials_path
      }
      env {
        name  = "USE_SECURE"
        value = "no"
      }
      env {
        name  = "ENV"
        value = "pro"
      }
      env {
        name  = "TRAIN_SERVER"
        value = "NA"
      }
      env {
        name  = "FACE_SERVER"
        value = "NA"
      }
      env {
        name  = "SEND_GRID_VARIABLE"
        value = local.secrets.postgress_pass
      }
      env {
        name  = "WORKSPACE"
        value = "/tmp/app"
      }
      env {
        name  = "NODE_SERVER_PATH"
        value = "/"
        #value = "/playground/"
      }
      resources {
        limits = {
          # 512Mi
          memory = "4Gi"
          # '1', '2', '4', and '8' 1000m 250m 500m
          cpu = "2"
        }
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "ALL_TRAFFIC"
    }
  }
  # Allow unauthenticated invocations
  traffic {
    type            = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent         = 100
  }

  ingress = "INGRESS_TRAFFIC_ALL"  # Allows all traffic, including unauthenticated
  deletion_protection = false
}

resource "google_cloud_run_service_iam_member" "no_auth_playground" {
  service     = google_cloud_run_v2_service.playground.name
  location    = google_cloud_run_v2_service.playground.location
  role        = "roles/run.invoker"
  member      = "allUsers"  # Allows all users to invoke the service
  depends_on = [google_cloud_run_v2_service.playground]
}

resource "google_compute_managed_ssl_certificate" "assessment" {
  name    = "${var.environment}-assessment-cert"
  managed {
    domains = ["assessment.solvista.me."]
  }
}

resource "google_cloud_run_domain_mapping" "assessment_mapping" {
  name     = "assessment.solvista.me"
  location = var.region

  metadata {
    namespace = var.project_name
    annotations = {
      "run.googleapis.com/managed-certificates" = "true"
    }
  }

  spec {
    route_name = google_cloud_run_v2_service.assessment.name
  }
}

resource "google_cloud_run_domain_mapping" "apps_mapping" {
  name     = "apps.solvista.me"
  location = var.region

  metadata {
    namespace = var.project_name
    annotations = {
      "run.googleapis.com/managed-certificates" = "true"
    }
  }

  spec {
    route_name = google_cloud_run_v2_service.nginx.name
  }
}
