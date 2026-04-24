
resource "google_compute_managed_ssl_certificate" "n8n" {
  name    = "${var.environment}-n8n-cert"
  managed {
    domains = [
      var.environment == "pro" ? "n8n.solvista.me." : "n8n-stg.solvista.me"
      ]
  }
}

resource "google_compute_address" "n8n_ip" {
  name   = "${var.environment}-nogales-n8n-ip"
  region = var.region
}

resource "google_compute_address" "auto_assigned_private_ip" {
  name         = "${var.environment}-auto-assigned-private-ip"
  subnetwork   = google_compute_subnetwork.nogales-subnetwork.name
  address_type = "INTERNAL"
  region       = var.region
  address      = "10.2.0.6"
}


resource "google_compute_address" "n8n_private_ip" {
  name         = "${var.environment}-n8n-private-ip"
  subnetwork   = google_compute_subnetwork.nogales-subnetwork.name
  address_type = "INTERNAL"
  region       = var.region
  address      = "10.2.0.7"
}

resource "google_compute_firewall" "n8n_server" {
  name    = "${var.environment}-n8n-server"
  network = google_compute_network.nogales-network.name


  allow {
    protocol = "tcp"
    ports    = ["5678"]
  }

  # Restrict to specific source IPs if possible
  source_ranges = ["0.0.0.0/0"]

  target_tags = ["n8n-server"]
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
        - name: N8N_PORT
          value: 5678
        - name: N8N_ENCRYPTION_KEY
          value: ${local.secrets.n8n.N8N_ENCRYPTION_KEY}
        - name: N8N_LICENSE_KEY
          value: ${local.secrets.n8n.N8N_LICENSE_KEY}
        - name: DB_TYPE
          value: postgresdb
        - name: DB_POSTGRESDB_HOST
          value: 127.0.0.1
        - name: DB_POSTGRESDB_PORT
          value: 5432
        - name: DB_POSTGRESDB_USER
          value: ${local.secrets.n8n.postgress.user}
        - name: DB_POSTGRESDB_PASSWORD
          value: ${local.secrets.n8n.postgress.pass}
        - name: DB_POSTGRESDB_DATABASE
          value: n8n
        - name: INSTANCE_CONNECTION_NAME
          value: ${google_sql_database_instance.general.connection_name}
        - name: EXECUTIONS_MODE
          value: regular
        - name: N8N_SECURE_COOKIE
          value: false
        - name: N8N_HOST
          value: localhost
        - name: N8N_PROTOCOL
          value: http
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
      nat_ip       = google_compute_address.n8n_ip.address
      network_tier = "PREMIUM"
    }
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    network     = google_compute_network.nogales-network.id
    subnetwork  = google_compute_subnetwork.nogales-subnetwork.id
    network_ip  = google_compute_address.n8n_private_ip.address
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email = google_service_account.n8n.email
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
    google_compute_address.n8n_ip,
    google_compute_address.n8n_private_ip,
  ]

  tags = ["ssh", "http-server", "https-server", "n8n-server"]
  zone = var.zone
}

# Group
resource "google_compute_instance_group" "n8n_group" {
  name        = "${var.environment}-n8n-group"
  zone        = var.zone
  instances   = [google_compute_instance.n8n_master.self_link]

  named_port {
    name = "https"
    port = "443"
  }

  network     = google_compute_network.nogales-network.id
}

# Health check
resource "google_compute_health_check" "n8n" {
  name = "${var.environment}-n8n-health-check"
  timeout_sec        = 10
  check_interval_sec = 10

  https_health_check {
    port         = 443
  }

  log_config {
    enable = false
  }
}