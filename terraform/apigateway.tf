/*
resource "google_api_gateway_api" "api" {
  provider = google-beta
  api_id   = "${var.environment}-api"
}

resource "google_api_gateway_api_config" "api_config" {
  provider      = google-beta
  api           = google_api_gateway_api.api.api_id
  api_config_id = "${var.environment}-api-config-v1-0-0"

  openapi_documents {
    document {
      path     = var.api_yml
      contents = filebase64("${var.api_yml}")
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "gateway" {
  provider   = google-beta
  gateway_id = "${var.environment}-gateway"
  api_config = google_api_gateway_api_config.api_config.id
  region     = var.region
}
# google_compute_network_endpoint_group
resource "google_compute_region_network_endpoint_group" "api_gateway_network_endpoint_group" {
  provider              = google-beta
  name                  = "${var.environment}-api-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  serverless_deployment {
    platform = "apigateway.googleapis.com"
    resource = google_api_gateway_gateway.gateway.gateway_id
  }
}
*/