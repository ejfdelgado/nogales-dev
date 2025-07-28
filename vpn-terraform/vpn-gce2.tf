
#ssh-keygen -f '/home/ejfdelgado/.ssh/known_hosts' -R '34.139.177.41'
#ssh -i ~/.ssh/id_ed25519 ejfdelgado@34.139.177.41
#docker ps
#docker exec -it 39da115d0818 /bin/bash

resource "google_compute_instance" "single_vpn" {
  count        = 1
  name         = "${var.environment}-nogales-single-vpn"
  # $24.46 / month
  machine_type = "e2-micro"
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
      volumeMounts:
        - name: vpn_config
          mountPath: /config
      securityContext:
        privileged: true
      env:
        - name: INTERNAL_SUBNET
          value: 10.128.0.0/9
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
  volumes:
    - name: vpn_config
      hostPath:
        path: /mnt/stateful_partition/persisten_disk/vpn_config
  restartPolicy: Always
YAML
    startup-script = <<-EOT
#!/bin/bash
mkdir -p /mnt/stateful_partition/persisten_disk
mount /dev/sdb /mnt/stateful_partition/persisten_disk
chmod 777 /mnt/stateful_partition/persisten_disk
mkdir -p /mnt/stateful_partition/persisten_disk/vpn_modules
mkdir -p /mnt/stateful_partition/persisten_disk/vpn_config
EOT
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

  tags = ["ssh", "allow-ssh"]
}
