
#ssh-keygen -f '/home/ejfdelgado/.ssh/known_hosts' -R '34.74.215.84'
#stage:
#ssh -i ~/.ssh/id_ed25519 ejfdelgado@34.74.215.84
#pro:
#ssh -i ~/.ssh/id_ed25519 ejfdelgado@34.139.191.241
#docker ps
#docker exec -it 58427691c63d /bin/bash

resource "google_compute_instance" "single_vpn" {
  name         = "${var.environment}-nogales-single-vpn"
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

  attached_disk {
    source      = google_compute_disk.stateful_disks[0].id
    device_name = "data-disk"
    mode        = "READ_WRITE"
  }

  labels = {
    environment  = var.environment
    application  = "nogales"
    service      = "${var.environment}-vpn"
    managed-by   = "terraform"
  }

  network_interface {
    access_config {
      nat_ip       = google_compute_address.vpn_ip.address
      network_tier = "PREMIUM"
    }
    network     = google_compute_network.nogales-vpn-network.id
  }

  metadata = {
    ssh-keys = join("\n", [
      local.secrets.ssh_ejfdelgado,
      local.secrets.ssh_rodalbores
      ])
    gce-container-declaration = <<-YAML
spec:
  containers:
    - image: ${var.vpn_image}
      name:  vpn-server
      volumeMounts:
        - name: vpn_config
          mountPath: /config
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
          value: 200
        - name: PEERDNS
          value: 1.1.1.1
        - name: ALLOWEDIPS
          value: 0.0.0.0/0
        - name: PERSISTENTKEEPALIVE_PEERS
          value: 
        - name: LOG_CONFS
          value: true
  volumes:
    - name: vpn_config
      hostPath:
        path: /mnt/stateful_partition/persisten_disk/vpn_config
  restartPolicy: Always
YAML
    startup-script = <<-EOT
      #!/bin/bash
      DISK_DEV="/dev/disk/by-id/google-data-disk"
      MNT_DIR="/mnt/stateful_partition/persisten_disk"

      while [ ! -e "$DISK_DEV" ]; do sleep 1; done

      if ! blkid $DISK_DEV; then
        mkfs.ext4 -F $DISK_DEV
      fi

      mkdir -p $MNT_DIR
      mount -o discard,defaults $DISK_DEV $MNT_DIR
      chmod 777 $MNT_DIR

      mkdir -p $MNT_DIR/vpn_config
      chmod 777 $MNT_DIR/vpn_config

      docker run --rm \
        -v /mnt/stateful_partition/persisten_disk/vpn_config:/data \
        gcr.io/google.com/cloudsdktool/google-cloud-cli:slim \
        gsutil -m cp -r /data/. gs://${var.environment}-nogales-github-credentials/vpn-config/
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
    email  = google_service_account.vpn.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  tags = ["ssh", "allow-ssh"]
}


resource "google_compute_managed_ssl_certificate" "vpn_certificate" {
  name    = "${var.environment}-vpn-cert"
  managed {
    domains = [
      var.environment == "pro" ? "vpn.solvista.me." : "vpn-stg.solvista.me."
      ]
  }
}