resource "google_compute_address" "chatbot_ip" {
  name   = "${var.environment}-chatbot-ip"
  region = var.region
}

resource "google_compute_instance" "single_vpn" {
  count = 0
  name         = "${var.environment}-chatbot"
  # n1-standard-1 => $35.67/ mo
  machine_type = "n1-standard-1"
  # n2d-standard-2 => $62.68/ mo
  #machine_type = "n2d-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  labels = {
    environment  = var.environment
    application  = "nogales"
    service      = "${var.environment}-chatbot"
    managed-by   = "terraform"
  }

  network_interface {
    #access_config {}
    access_config {
      nat_ip       = google_compute_address.chatbot_ip.address
      network_tier = "PREMIUM"
    }
    network     = google_compute_network.nogales-network.id
  }

  metadata = {
    ssh-keys = join("\n", [
      local.secrets.ssh_ejfdelgado,
      local.secrets.ssh_rodalbores
      ])
    gce-container-declaration = <<-YAML
spec:
  containers:
    - image: ${var.chatbot_image}
      name:  chatbot-server
      securityContext:
        privileged: true
      env:
        - name: NAME
          value: 10
  restartPolicy: Always
YAML
    startup-script = <<-EOT
      #!/bin/bash
      
EOT
    google-logging-enabled    = "true"
    # Help keep the image disk space free
    google-monitoring-enabled = "true"
    docker-gc-enabled = "true"
  }

  shielded_instance_config {
    enable_integrity_monitoring = false
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  service_account {
    email  = google_service_account.chatbot.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [
    google_compute_address.chatbot_ip,
    google_service_account.chatbot,
    google_project_iam_member.chatbot_instance_sa_roles
    ]

  tags = ["http-server", "https-server"]
}

