resource "google_compute_region_instance_group_manager" "example_group" {
  name               = "${var.environment}-nogales-vpn"
  base_instance_name = "${var.environment}-nogales-vpn-base"
  region             = var.region
  version {
    instance_template = google_compute_instance_template.vpn_server.self_link
  }

  target_size = 1

  named_port {
    name = "vpn-port"
    port = 51820
  }

  #auto_healing_policies {
  #  health_check      = google_compute_health_check.default.self_link
  #  initial_delay_sec = 60
  #}
}