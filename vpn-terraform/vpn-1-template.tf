
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
          value: 1
        - name: PEERDNS
          value: auto
        - name: ALLOWEDIPS
          value: 0.0.0.0/0
        - name: PERSISTENTKEEPALIVE_PEERS
          value: 
        - name: LOG_CONFS
          value: true
      securityContext:
        privileged: true
      ports:
        - name: vpn-port
          containerPort: 51820
          protocol: UDP
      stdin: false
      tty: false
      volumeMounts: []
      restartPolicy: Always
      volumes: []
EOT
  }

  tags = ["gce-container"]
}
