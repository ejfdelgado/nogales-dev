environment = "stg"

#############################################
# DOCKER IMAGES
#############################################
docker_image_speedmeter = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_speedmeter:1.0.0"
assessment_image = "us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_assessment_front_back:1.49.4"
videocall_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_videocall_front_back:2.19.2"
turn_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_turn:1.3.0"
wordpress_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:3.0.8"
n8n_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/n8n:2.17.5.3"
chatbot_image="us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/nogales_chatbot:1.0.0"
vpn_config_image="us-central1-docker.pkg.dev/local-volt-431316-m2/cloud-run-source-deploy/stg-nogales-vpn-config:1.3.1"
web_flow_image="us-central1-docker.pkg.dev/local-volt-431316-m2/cloud-run-source-deploy/stg-nogales-web-flow:1.1.2"

#############################################
# ASSESSMENT
#############################################
assessment_cors="https://test.solvista.me;https://stg-assessment-284609972807.us-central1.run.app;https://apps.solvista.me;https://casa-de-la-familia-3c766f.design.webflow.com;https://casa-de-la-familia-3c766f.webflow.io;https://stg-nogales-assets.storage.googleapis.com;https://apps-stg.solvista.me"
assessment_domain="https://stg-assessment-284609972807.us-central1.run.app"

#############################################
# N8N
#############################################
n8n_machine_type="n2-standard-2"
n8n_memory_limit="6Gi"
n8n_disktype="pd-balanced"

#############################################
# VIDEO CALL
#############################################
videocall_machine_type="n2-standard-2"
videocall_memory_limit="7Gi"
videocall_soup_ip="104.197.163.219"
videocall_autorecovery="0"
max_node_memory="6000"
soup_max_worker_load="2"
videocall_disktype="pd-balanced"
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

#############################################
# DATABASE
#############################################
# 1vcpu 1.7GB
sql_type="db-g1-small"
# 1vcpu 3.75 GB = 3840/1024
#sql_type="db-custom-1-3840"

#############################################
# OTHERS
#############################################
heymarket_end_point="https://api.heymarket.com"

#############################################
# VPN config
#############################################
vpn_config_cors="https://apps-stg.solvista.me"

#############################################
# Web Flow
#############################################
email_recipient="edgar.jose.fernando.delgado@gmail.com"
email_sender="no_reply@nogalespsychological.com"
mailchimp_api_key=""
mailchimp_subscription_list=""
web_flow_cors="https://casa-de-la-familia-3c766f.design.webflow.com;https://casa-de-la-familia-3c766f.webflow.io"