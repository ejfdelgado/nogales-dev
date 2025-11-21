
resource "google_compute_instance" "videocall" {
  #count = var.environment == "pro" ? 1 : 0
  name     = "${var.environment}-nogales-videocall"
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = true
    device_name = "${var.environment}-nogales-videocall"

    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-113-18244-85-29"
      size  = 50
      #type  = var.environment == "pro" ? "hyperdisk-balanced" : "pd-balanced"
      #type  = "hyperdisk-balanced"
      #type  = "pd-balanced"
      type = var.videocall_disktype
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

  # n1-standard-1 = 3.7G = 36 usd/month
  # n1-standard-2 = 7.5G = 70 usd/month
  # n1-highmem-2 = 2vcp 13G = 88 usd/month
  # n2-standard-2 = 2vCPUs, 8 GiB = 72usd/m
  # n4-standard-4 = vCPUs: 4, RAM: 16 GiB = 140usd/mont
  # n4-standard-8 = 8vcpu 32G = 278 usd/month (incompatible)
  # n4-highcpu-16 = 16vcpu 32GB = 468 usd/month (Enable 10 Gbps networking (comes with ≥16 vCPU VMs by default).)
  #machine_type = var.environment == "pro" ? "n2-standard-2" : "n4-standard-8"
  # custom-16-14848 16vcpu and 14G
  # custom-4-3840
  # --------------
  # c4-highcpu-8 = 4vcpu 16G = 250usd
  # n1-highcpu-16 = 8vcpu 16G = 290usd (causes error)
  machine_type = var.environment == "pro" ? "n1-highcpu-16" : "n2-standard-2"

  metadata = {
    ssh-keys = join("\n", [
      local.secrets.ssh_ejfdelgado,
      local.secrets.ssh_rodalbores
      ])
    gce-container-declaration = <<EOT
spec:
  containers:
    - image: ${var.videocall_image}
      name:  nogalesserver
      resources:
        limits:
          memory: "10Gi"
      env:
        - name: GOOGLE_APPLICATION_CREDENTIALS
          value: ${var.credentials_path}
        - name: PORT
          value: 443
        - name: USE_SECURE
          value: yes
        - name: ENV
          value: pro
        - name: TRAIN_SERVER
          value: NA
        - name: FACE_SERVER
          value: NA
        - name: SEND_GRID_VARIABLE
          value: ${local.secrets.sendgrid_apikey}
        - name: EMAIL_SENDER
          value: ${var.email_sender}
        - name: WORKSPACE
          value: /tmp/app
        - name: NODE_SERVER_PATH
          value: /
        - name: BUCKET_PUBLIC
          value: ${var.environment}-nogales-public
        - name: BUCKET_PRIVATE
          value: ${var.environment}-nogales-private
        - name: POSTGRES_HOST
          value: ${local.secrets.postgress.host}
        - name: POSTGRES_PORT
          value: ${local.secrets.postgress.port}
        - name: POSTGRES_DB
          value: ${local.secrets.postgress.db}
        - name: POSTGRES_USER
          value: ${local.secrets.postgress.user}
        - name: POSTGRES_PASSWORD
          value: "${local.secrets.postgress.pass}"
        - name: HEY_MARKET_API_KEY
          value: ${local.secrets.heymarket.HEY_MARKET_API_KEY}
        - name: HEY_MARKET_SENDER_ID
          value: ${local.secrets.heymarket.HEY_MARKET_SENDER_ID}
        - name: HEY_MARKET_INBOX_ID
          value: ${local.secrets.heymarket.HEY_MARKET_INBOX_ID}
        - name: HEY_MARKET_END_POINT
          value: ${var.heymarket_end_point}
        - name: AUTH_GROUP_ID_MAP
          value: ${var.auth_group_id_map}
        - name: AUTH_PROVIDER
          value: ${local.secrets.authentication.AUTH_PROVIDER}
        - name: MICROSOFT_CLIENT_ID
          value: ${local.secrets.authentication.MICROSOFT_CLIENT_ID}
        - name: MICROSOFT_TENANT
          value: ${local.secrets.authentication.MICROSOFT_TENANT}
        - name: WEBRTC_CONF
          value: ${var.webrtc_config}
        - name: REBOOT_TIME
          value: 7:30
        - name: SERVER_ZONE
          value: ${var.zone}
        - name: SERVER_PROJECT
          value: ${var.project_name}
        - name: SERVER_INSTANCE_NAME
          value: ${var.environment}-nogales-videocall
        - name: SOUP_ANNOUNCED_IP
          value: ${var.videocall_soup_ip}
        - name: USE_AUTORECOVERY_PROCESS
          value: ${var.videocall_autorecovery}
        - name: AVOID_REBOOT_ON_ERROR
          value: 1
        - name: MAX_SOUP_WORKER_LOAD
          value: ${var.soup_max_worker_load}
        - name: NODE_OPTIONS
          value: --max-old-space-size=${var.max_node_memory}
        - name: COMPUTE_DAILY_STATISTICS
          value: 1
        - name: REPLACER_USER
          value: aquintana@nogalespsychological.com
        - name: NO_PAGES
          value: 1
      securityContext:
        privileged: true
      stdin: false
      tty: false
      volumeMounts: []
      restartPolicy: Always
      volumes: []
EOT
    google-logging-enabled    = "true"
    startup-script = var.videocall_script

# gce-container-declaration deprecation at July 31, 2026
#  metadata = {
#    startup-script = <<-EOT
#      #!/bin/bash
#      # Pull the Docker image
#      docker pull gcr.io/your-project/your-node-image:latest
#
#      # Run the container with a memory limit
#      docker run -d --restart=always --name node-server --memory=14g \
#        gcr.io/your-project/your-node-image:latest
#    EOT
#  }

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

  tags = ["ssh", "http-server", "https-server", "mediasoup-server"]
  zone = var.zone

  metadata_startup_script = <<-EOF
    #!/bin/bash
    
    mkdir -p /cloudsql
    chmod 777 /cloudsql

    curl -o /usr/local/bin/cloud-sql-proxy \
      https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.10.0/cloud-sql-proxy.linux.amd64

    chmod +x /usr/local/bin/cloud-sql-proxy

    /usr/local/bin/cloud-sql-proxy \
      --unix-socket-path=/cloudsql \
      ${google_sql_database_instance.general.connection_name} \
      >/var/log/cloudsql-proxy.log 2>&1 &
  EOF
}

resource "google_compute_instance_group" "videocallgroup" {
  #count = var.environment == "pro" ? 1 : 0
  name        = "${var.environment}-videocall-group"
  zone        = var.zone
  # instances   = [google_compute_instance.videocall[count.index].self_link]
  instances   = [google_compute_instance.videocall.self_link]

  named_port {
    #name = "http"
    #port = "80"
    name = "https"
    port = "443"
  }

  network     = google_compute_network.nogales-network.id
}

resource "google_compute_health_check" "videocall" {
  #count = var.environment == "pro" ? 1 : 0
  name = "${var.environment}-health-check"
  timeout_sec        = 10
  check_interval_sec = 10

  #http_health_check {
  # port = 80
  #}

  https_health_check {
    port         = 443
    #request_path = "/health"
    #validate_ssl = false
  }

  log_config {
    enable = false
  }
}

resource "google_compute_backend_service" "videocallbkservice" {
  #count = var.environment == "pro" ? 1 : 0
  name     = "${var.environment}-videocall-bksrv"
  #protocol = "HTTP"

  protocol              = "HTTPS"
  port_name             = "https"
  timeout_sec           = 7200
  enable_cdn            = true

  cdn_policy {
    cache_mode                    = "CACHE_ALL_STATIC"  # Options: "CACHE_ALL_STATIC", "USE_ORIGIN_HEADERS", "FORCE_CACHE_ALL"
    default_ttl                   = 43200                  # in seconds 12 h = 60x60x12
    max_ttl                       = 43200                 # in seconds
    client_ttl                    = 43200                   # in seconds
    negative_caching              = true
    serve_while_stale             = 86400
    cache_key_policy {
      include_protocol            = true
      include_host                = true
      include_query_string        = true
      #query_string_whitelist      = ["id", "l"]
    }
  }

  backend {
    #group = google_compute_instance_group.videocallgroup[count.index].self_link
    group = google_compute_instance_group.videocallgroup.self_link
  }

  health_checks = [
    #google_compute_health_check.videocall[count.index].self_link
    google_compute_health_check.videocall.self_link
    ]
}

resource "google_compute_managed_ssl_certificate" "default" {
  #count = var.environment == "pro" ? 1 : 0
  name    = "${var.environment}-videocall-cert"
  managed {
    domains = [
      var.environment == "pro" ? "video.solvista.me." : "video-stg.solvista.me"
      ]
  }
}

resource "google_compute_url_map" "videocallmap" {
  #count = var.environment == "pro" ? 1 : 0
  name        = "${var.environment}-videocall-map"

  #default_service = google_compute_backend_service.videocallbkservice[count.index].id
  default_service = google_compute_backend_service.videocallbkservice.id

  host_rule {
    hosts        = [
      var.environment == "pro" ? "video.solvista.me" : "video-stg.solvista.me"
      ]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    #default_service = google_compute_backend_service.videocallbkservice[count.index].id
    default_service = google_compute_backend_service.videocallbkservice.id

    path_rule {
      paths   = ["/*"]
      #service = google_compute_backend_service.videocallbkservice[count.index].id
      service = google_compute_backend_service.videocallbkservice.id
    }
  }
}

resource "google_compute_target_https_proxy" "default" {
  #count = var.environment == "pro" ? 1 : 0
  name             = "${var.environment}-videocall-proxy"
  #url_map          = google_compute_url_map.videocallmap[count.index].id
  url_map          = google_compute_url_map.videocallmap.id
  #ssl_certificates = [google_compute_managed_ssl_certificate.default[count.index].id]
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_global_forwarding_rule" "default" {
  #count = var.environment == "pro" ? 1 : 0
  name       = "${var.environment}-videocall-forward"
  #target     = google_compute_target_https_proxy.default[count.index].id
  target     = google_compute_target_https_proxy.default.id
  port_range = 443
}