environment = "pro"

docker_image_speedmeter = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_speedmeter:0.1.0"
assessment_image = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_assessment_front_back:1.46.1"
videocall_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_videocall_front_back:2.18.18"
turn_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_turn:1.3.0"
wordpress_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:3.0.8"
n8n_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/n8n:2.17.5.3"

n8n_machine_type="n2-standard-4"
n8n_memory_limit="14Gi"

videocall_machine_type="n1-highcpu-16"
videocall_memory_limit="12Gi"

heymarket_end_point="https://api.heymarket.com"
assessment_cors="https://test.solvista.me;https://stg-assessment-284609972807.us-central1.run.app;https://apps.solvista.me;https://casa-de-la-familia-3c766f.design.webflow.com"
assessment_domain="https://test.solvista.me"
# 1vcpu 3.75 GB = 3840/1024 = $66.31
#sql_type="db-custom-1-3840"
# 2vcpu 3.75 GB = 3840/1024 = $96.46
sql_type="db-custom-2-3840"
# 2vcpu 8GB = 8192 / 1024 = $118
#sql_type="db-custom-2-8192"
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
n8n_disktype="pd-balanced"
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

      # Removes all images but keeps images used in the last 7 days
      #docker image prune -af --filter "until=168h"

      # Apply changes immediately
      sysctl --system
EOT
