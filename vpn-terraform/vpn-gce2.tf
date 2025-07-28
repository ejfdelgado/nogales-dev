
#ssh -i ~/.ssh/id_ed25519 ejfdelgado@34.139.177.41
#docker ps
#docker exec -it 7c7dbf47edf6 /bin/bash

resource "google_compute_instance" "single_vpn" {
  count = 1
  name         = "${var.environment}-nogales-single-vpn"
  # $24.46 / month
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network     = google_compute_network.nogales-vpn-network.id
    access_config {
    }
  }

  metadata = {
    ssh-keys = local.secrets.ssh_ejfdelgado
    gce-container-declaration = <<-YAML
spec:
  containers:
    - image: ${var.vpn_image}
      name:  vpn-server
      volumeMounts: []
      securityContext:
        privileged: true
      env:
        - name: INTERNAL_SUBNET
          value: 10.13.13.0
        - name: PUID
          value: 1000
        - name: PGID
          value: 1000
        - name: TZ
          value: Etc/UTC
        - name: SERVERPORT
          value: 51820
        - name: PEERS
          value: 3
        - name: PEERDNS
          value: auto
        - name: ALLOWEDIPS
          value: 0.0.0.0/0
        - name: PERSISTENTKEEPALIVE_PEERS
          value: 
        - name: LOG_CONFS
          value: true
  volumes: []
  restartPolicy: Always
YAML
    google-logging-enabled    = "true"
  }

  shielded_instance_config {
    enable_integrity_monitoring = false
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }

  #service_account {
  #  email = "${var.email_gce_service_account}"
  #  scopes = [
  #    "https://www.googleapis.com/auth/devstorage.read_only",
  #    "https://www.googleapis.com/auth/logging.write",
  #    "https://www.googleapis.com/auth/monitoring.write",
  #    "https://www.googleapis.com/auth/service.management.readonly",
  #    "https://www.googleapis.com/auth/servicecontrol",
  #    "https://www.googleapis.com/auth/trace.append"
  #  ]
  #}

  tags = ["ssh", "allow-ssh"]
}
