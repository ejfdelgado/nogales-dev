
resource "google_compute_instance" "turn" {
  name     = "${var.environment}-nogales-turn"

  boot_disk {
    auto_delete = true
    device_name = "${var.environment}-nogales-turn"

    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-113-18244-85-29"
      size  = 50
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    container-vm = "cos-stable-113-18244-85-29"
    goog-ec-src  = "vm_add-tf"
  }

  machine_type = "n1-standard-1"

  metadata = {
    gce-container-declaration = <<EOT
spec:
  containers:
    - image: ${var.turn_image}
      name:  nogalesturn
      env:
        - name: USERNAME
          value: ${local.secrets.turn_user}
        - name: PASSWORD
          value: ${local.secrets.turn_pass}
        - name: REALM
          value: nogales
        - name: MIN_PORT
          value: 49152
        - name: MAX_PORT
          value: 65535
      securityContext:
        privileged: true
      stdin: false
      tty: false
      volumeMounts: []
      restartPolicy: Always
      volumes: []
EOT
    google-logging-enabled    = "true"
  }

  network_interface {
    access_config {
      nat_ip       = google_compute_address.turn_ip.address
      network_tier = "PREMIUM"
    }
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    network     = google_compute_network.nogales-network.id
    subnetwork  = google_compute_subnetwork.nogales-subnetwork.id
    network_ip  = google_compute_address.nogales_private_turn_ip.address
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email = "${var.email_gce_service_account}"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["turn-server", "http-server", "https-server"]
  zone = var.zone
}

resource "google_compute_instance_group" "turngroup" {
  name        = "${var.environment}-turn-group"
  zone        = var.zone
  instances   = [google_compute_instance.turn.self_link]

  named_port {
    name = "http"
    port = "80"
  }

  network     = google_compute_network.nogales-network.id
}

resource "google_compute_health_check" "turn" {
  name = "${var.environment}-turn-healthcheck"
  timeout_sec        = 5
  check_interval_sec = 5
  http_health_check {
    port = 80
  }
}


resource "google_compute_backend_service" "turnbkservice" {
  name     = "${var.environment}-turn-bksrv"
  protocol = "HTTP"

  backend {
    group = google_compute_instance_group.turngroup.self_link
  }

  health_checks = [google_compute_health_check.turn.self_link]
}


resource "google_compute_managed_ssl_certificate" "turn" {
  name    = "${var.environment}-turn-cert"
  managed {
    domains = ["turn.solvista.me."]
  }
}

resource "google_compute_url_map" "turnmap" {
  name        = "${var.environment}-turn-map"

  default_service = google_compute_backend_service.turnbkservice.id

  host_rule {
    hosts        = ["turn.solvista.me"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.turnbkservice.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.turnbkservice.id
    }
  }
}

resource "google_compute_target_https_proxy" "turn" {
  name             = "${var.environment}-turn-proxy"
  url_map          = google_compute_url_map.turnmap.id
  ssl_certificates = [google_compute_managed_ssl_certificate.turn.id]
}

resource "google_compute_global_forwarding_rule" "turn" {
  name       = "${var.environment}-turn-forward"
  target     = google_compute_target_https_proxy.turn.id
  port_range = 443
}