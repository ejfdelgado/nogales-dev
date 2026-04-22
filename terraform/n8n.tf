
resource "google_compute_managed_ssl_certificate" "n8n" {
  name    = "${var.environment}-n8n-cert"
  managed {
    domains = [
      var.environment == "pro" ? "n8n.solvista.me." : "n8n-stg.solvista.me"
      ]
  }
}