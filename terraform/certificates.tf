resource "google_compute_managed_ssl_certificate" "n8n" {
  name    = "${var.environment}-n8n-cert"
  managed {
    domains = [
      var.environment == "pro" ? "n8n.solvista.me." : "n8n-stg.solvista.me"
      ]
  }
}

resource "google_compute_managed_ssl_certificate" "default" {
  name    = "${var.environment}-videocall-cert"
  managed {
    domains = [
      var.environment == "pro" ? "video.solvista.me." : "video-stg.solvista.me"
      ]
  }
}

resource "google_compute_managed_ssl_certificate" "assessment" {
  count = var.environment == "pro" ? 1 : 0
  name    = "${var.environment}-assessment-cert"
  managed {
    domains = ["test.solvista.me."]
  }
}