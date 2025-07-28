
resource "google_compute_instance" "bastion" {
  count        = 0
  name         = "${var.environment}-nogales-bastion"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  attached_disk {
    source      = google_compute_disk.stateful_disks[0].id
    device_name = "data-disk"
    mode        = "READ_WRITE"
  }

  network_interface {
    network = "default"

    access_config {

    }
  }

  metadata = {
  "startup-script" = <<-EOT
    #!/bin/bash
    DISK_DEV="/dev/disk/by-id/google-data-disk"
    MNT_DIR="/mnt/persisten_disk"

    # Wait for disk
    while [ ! -e "$DISK_DEV" ]; do sleep 1; done

    # Format if needed
    if ! blkid $DISK_DEV; then
      mkfs.ext4 -F $DISK_DEV
    fi

    mkdir -p $MNT_DIR
    mount -o discard,defaults $DISK_DEV $MNT_DIR
    chmod 777 $MNT_DIR

    # Make wireguard config dir
    mkdir -p $MNT_DIR/vpn_modules
    mkdir -p $MNT_DIR/vpn_config
  EOT
  }

  tags = ["ssh"]
}
