
resource "google_compute_managed_ssl_certificate" "n8n" {
  name    = "${var.environment}-n8n-cert"
  managed {
    domains = [
      var.environment == "pro" ? "n8n.solvista.me." : "n8n-stg.solvista.me"
      ]
  }
}

resource "google_compute_instance" "n8n_master" {
  name     = "${var.environment}-nogales-n8n-master"
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = true
    device_name = "${var.environment}-nogales-n8n-master"

    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-113-18244-85-29"
      size  = 50
      type = var.n8n_disktype
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

  machine_type = var.environment == "pro" ? "n1-highcpu-16" : "n2-standard-2"

  metadata = {
    ssh-keys = join("\n", [
      local.secrets.ssh_ejfdelgado,
      local.secrets.ssh_rodalbores
      ])
    gce-container-declaration = <<EOT
spec:
  containers:
    - image: ${var.n8n_image}
      name:  n8n_master_server
      resources:
        limits:
          memory: "10Gi"
      env:
        - name: N8N_BASIC_AUTH_ACTIVE
          value: true
        - name: N8N_BASIC_AUTH_USER
          value: admin
        - name: N8N_BASIC_AUTH_PASSWORD
          value: ${local.secrets.n8n.N8N_BASIC_AUTH_PASSWORD}
        - name: GENERIC_TIMEZONE
          value: America/Los_Angeles
        - name: N8N_HOST
          value: localhost
        - name: N8N_PORT
          value: 5678
        - name: N8N_PROTOCOL
          value: http
        - name: N8N_ENCRYPTION_KEY
          value: ${local.secrets.n8n.N8N_ENCRYPTION_KEY}
        - name: POSTGRES_USER
          value: ${local.secrets.n8n.postgress.user}
        - name: POSTGRES_PASSWORD
          value: ${local.secrets.n8n.postgress.pass}
        - name: POSTGRES_DB
          value: n8n
        - name: N8N_LICENSE_KEY
          value: ${local.secrets.n8n.N8N_LICENSE_KEY}
      securityContext:
        privileged: true
      stdin: false
      tty: false
      volumeMounts: []
      restartPolicy: Always
      volumes: []
EOT
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
    docker-gc-enabled = "true"

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
    email = google_service_account.n8n.email
    #email = var.email_gce_service_account
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  depends_on = [
    google_service_account.n8n,
    google_project_iam_member.n8n_instance_sa_roles,
  ]

  tags = ["ssh", "http-server", "https-server"]
  zone = var.zone
}