environment = "stg"

docker_image_speedmeter = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_speedmeter:0.1.2"
assessment_image = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_assessment_front_back:1.47.2"
videocall_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_videocall_front_back:2.19.0"
turn_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_turn:1.3.0"
wordpress_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:3.0.8"
n8n_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/n8n:2.17.5.3"

n8n_machine_type="n2-standard-2"
n8n_memory_limit="6Gi"

videocall_machine_type="n2-standard-2"
videocall_memory_limit="7Gi"

heymarket_end_point="https://api.heymarket.com"
assessment_cors="https://test.solvista.me;https://stg-assessment-284609972807.us-central1.run.app;https://apps.solvista.me;https://casa-de-la-familia-3c766f.design.webflow.com;https://casa-de-la-familia-3c766f.webflow.io"
assessment_domain="https://stg-assessment-284609972807.us-central1.run.app"
# 1vcpu 1.7GB
sql_type="db-g1-small"
# 1vcpu 3.75 GB = 3840/1024
#sql_type="db-custom-1-3840"
videocall_soup_ip="104.197.163.219"
videocall_autorecovery="0"
max_node_memory="6000"
soup_max_worker_load="2"
videocall_disktype="pd-balanced"
n8n_disktype="pd-balanced"
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

      # Removes all images but keeps images used in the last 7 days
      #docker image prune -af --filter "until=168h"

      # Apply changes immediately
      sysctl --system
EOT
