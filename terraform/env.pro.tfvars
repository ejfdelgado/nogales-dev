environment = "pro"
credentials_path="/tmp/app/credentials/local-volt-431316-m2-4fe954a04994.json"
email_gce_service_account="284609972807-compute@developer.gserviceaccount.com"
assessment_image = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_assessment_front_back:1.38.3"
videocall_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_videocall_front_back:2.5.1"
turn_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_turn:1.3.0"
heymarket_end_point="https://api.heymarket.com"
sql_type="db-custom-1-3840"
videocall_soup_ip="34.171.61.38"
videocall_autorecovery="0"
# value in MB -> here around 9GB
max_node_memory="9000"
# Magic number
# 26214400 = 1024*1024*25
# 23068672 = 1024*1024*22
videocall_script=<<-EOT
      #!/bin/bash
      set -e

      # Sysctl tuning for high RTP load
      cat <<EOF >/etc/sysctl.d/99-mediasoup.conf
      # Maximum receive buffer size 23068672
      net.core.rmem_max = 23068672
      # Maximum send buffer size
      net.core.wmem_max = 23068672
      net.core.rmem_default = 23068672
      net.core.wmem_default = 23068672
      # UDP memory limits (in pages; 1 page = usually 4096 bytes)
      # Format: min default max (65536 131072 262144)
      # ~256 MB max kernel memory for all UDP sockets (262144 pages x 4 KB).
      net.ipv4.udp_mem = 65536 131072 262144
      EOF

      # Apply changes immediately
      sysctl --system
EOT
