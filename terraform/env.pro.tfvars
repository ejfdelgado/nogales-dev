environment = "pro"
credentials_path="/tmp/app/credentials/local-volt-431316-m2-4fe954a04994.json"
email_gce_service_account="284609972807-compute@developer.gserviceaccount.com"
docker_image_speedmeter = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_speedmeter:0.1.0"
assessment_image = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_assessment_front_back:1.39.11"
videocall_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_videocall_front_back:2.18.8"
turn_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_turn:1.3.0"
wordpress_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:3.0.5"
heymarket_end_point="https://api.heymarket.com"
sql_type="db-custom-1-3840"
videocall_soup_ip="34.171.61.38"
videocall_autorecovery="0"
# value in MB -> here around 9GB
max_node_memory="9000"
# Always this muts be 32, it is the maximum of concurrent calls.
# 2(soup_max_worker_load)x16(vcpu)=32
# 4(soup_max_worker_load)x8(vcpu)=32
soup_max_worker_load="4"
#videocall_disktype="hyperdisk-balanced"
videocall_disktype="pd-balanced"
# Magic number
# 26214400 = 1024*1024*25
# 23068672 = 1024*1024*22
# 14680064 = 1024*1024*16
videocall_script=<<-EOT
      #!/bin/bash
      set -e

      # Sysctl tuning for high RTP load
      cat <<EOF >/etc/sysctl.d/99-mediasoup.conf
      # Maximum receive buffer size 14680064
      net.core.rmem_max = 14680064
      # Maximum send buffer size
      net.core.wmem_max = 14680064
      net.core.rmem_default = 14680064
      net.core.wmem_default = 14680064
      # UDP memory limits (in pages; 1 page = usually 4096 bytes)
      # Format: min default max (65536 131072 146800)
      # ~256 MB max kernel memory for all UDP sockets (146800 pages x 4 KB).
      net.ipv4.udp_mem = 65536 131072 146800
      EOF

      # Apply changes immediately
      sysctl --system
EOT
