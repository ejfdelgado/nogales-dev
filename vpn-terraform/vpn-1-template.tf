resource "google_compute_instance_template" "vpn_server" {
  name         = "${var.environment}-nogales-vpn"
  machine_type = "e2-medium"
  region       = var.region

  disk {
    auto_delete  = true
    boot         = true
    # Container-Optimized OS
    source_image = "projects/cos-cloud/global/images/family/cos-stable"
  }

  network_interface {
    network     = google_compute_network.nogales-vpn-network.id
    access_config {}
  }

  metadata = {
    "gce-container-declaration" = <<EOT
spec:
  containers:
    - image: ${var.vpn_image}
      name:  nogalesserver
      env:
        - name: MY_KEY
          value: MY_VALUE
      securityContext:
        privileged: true
      stdin: false
      tty: false
      volumeMounts: []
      restartPolicy: Always
      volumes: []
EOT
  }

  tags = ["gce-container"]
}
