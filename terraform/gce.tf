
resource "google_compute_instance" "videocall" {
  name     = "${var.environment}-nogales-videocall"

  boot_disk {
    auto_delete = false
    device_name = "${var.environment}-nogales-videocall"

    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-113-18244-85-29"
      size  = 100
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
    - image: ${var.videocall_image}
      name:  nogalesserver
      env:
        - name: GOOGLE_APPLICATION_CREDENTIALS
          value: ${var.credentials_path}
        - name: PORT
          value: 80
        - name: USE_SECURE
          value: no
        - name: ENV
          value: ${var.environment}
        - name: TRAIN_SERVER
          value: NA
        - name: FACE_SERVER
          value: NA
        - name: SEND_GRID_VARIABLE
          value: ${local.secrets.postgress_pass}
        - name: EMAIL_SENDER
          value: ${var.email_sender}
        - name: WORKSPACE
          value: /tmp/app
        - name: NODE_SERVER_PATH
          value: /videocall/
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
      nat_ip       = google_compute_address.videcall_ip.address
      network_tier = "PREMIUM"
    }
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    network     = google_compute_network.nogales-network.id
    subnetwork  = google_compute_subnetwork.nogales-subnetwork.id
    network_ip  = google_compute_address.nogales_private_ip.address
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

  tags = ["ssh", "http-server", "https-server"]
  zone = var.zone
}

resource "google_compute_network_endpoint_group" "neg" {
  name                  = "private-neg"
  network_endpoint_type = "GCE_VM_IP_PORT"
  network               = google_compute_network.nogales-network.name
  subnetwork            = google_compute_subnetwork.nogales-subnetwork.name
  zone                  = var.zone
}


resource "google_compute_network_endpoints" "default-endpoints" {
  network_endpoint_group = google_compute_network_endpoint_group.neg.name
  depends_on = [google_compute_instance.videocall]

  network_endpoints {
    instance = google_compute_instance.videocall.name
    ip_address = google_compute_instance.videocall.network_interface[0].network_ip
    port = 80
  }
}

resource "google_compute_http_health_check" "videocall" {
  name               = "${var.environment}-videocall-hc"
  request_path       = "/assets/leame.txt"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_health_check" "videocall" {
  name = "health-check"
  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "videocall-lb" {
  name                  = "${var.environment}-videocall-lb"
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "HTTP"
  health_checks = [google_compute_health_check.videocall.id]

  backend {
    group = google_compute_network_endpoint_group.neg.id
    balancing_mode = "RATE"
    max_rate = 100
  }
}