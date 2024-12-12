### VPC ###
resource "google_compute_network" "main_vpc_network" {
  project                 = google_project.default_project.name
  name                    = "vpc-main-${var.environment}"
  auto_create_subnetworks = false
  mtu                     = 1460
}
### SUBNETS ###
resource "google_compute_subnetwork" "subnet_001" {
  name          = "snet-${var.environment}-001"
  ip_cidr_range = var.subnet001_cidr_range
  region        = var.location
  network       = google_compute_network.main_vpc_network.id
  #   secondary_ip_range {
  #     range_name    = "tf-test-secondary-range-update1"
  #     ip_cidr_range = "192.168.10.0/24"
  #   }
}
# backend subnet
resource "google_compute_subnetwork" "backend" {
  name          = "snet-backend-${var.environment}"
  provider      = google-beta
  ip_cidr_range = var.snet_backend_ip_cidr_range
  region        = var.location
  network       = google_compute_network.main_vpc_network.id
}
# frontend subnet
resource "google_compute_subnetwork" "frontend" {
  name          = "snet-frontend-${var.environment}"
  provider      = google-beta
  ip_cidr_range = var.snet_frontend_ip_cidr_range
  region        = var.location
  network       = google_compute_network.main_vpc_network.id
}
# health check
resource "google_compute_health_check" "default" {
  name = "hc-default-test-${var.environment}"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}
# allow access from health check ranges
resource "google_compute_firewall" "default" {
  name          = "allow-hc-default-test-${var.environment}"
  provider      = google-beta
  direction     = "INGRESS"
  network       = google_compute_network.main_vpc_network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}

# # reserved IP address
# resource "google_compute_global_address" "default" {
#   provider = google-beta
#   name     = "l7-xlb-static-ip"
# }

# # forwarding rule
# resource "google_compute_global_forwarding_rule" "default" {
#   name                  = "l7-xlb-forwarding-rule"
#   provider              = google-beta
#   ip_protocol           = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   port_range            = "80"
#   target                = google_compute_target_http_proxy.default.id
#   ip_address            = google_compute_global_address.default.id
# }

# # http proxy
# resource "google_compute_target_http_proxy" "default" {
#   name     = "l7-xlb-target-http-proxy"
#   provider = google-beta
#   url_map  = google_compute_url_map.default.id
# }

# # url map
# resource "google_compute_url_map" "default" {
#   name            = "l7-xlb-url-map"
#   provider        = google-beta
#   default_service = google_compute_backend_service.default.id
# }

# # backend service with custom request and response headers
# resource "google_compute_backend_service" "default" {
#   name                    = "l7-xlb-backend-service"
#   provider                = google-beta
#   protocol                = "HTTP"
#   port_name               = "my-port"
#   load_balancing_scheme   = "EXTERNAL"
#   timeout_sec             = 10
#   enable_cdn              = true
#   custom_request_headers  = ["X-Client-Geo-Location: {client_region_subdivision}, {client_city}"]
#   custom_response_headers = ["X-Cache-Hit: {cdn_cache_status}"]
#   health_checks           = [google_compute_health_check.default.id]
#   backend {
#     group           = google_compute_instance_group_manager.default.instance_group
#     balancing_mode  = "UTILIZATION"
#     capacity_scaler = 1.0
#   }
# }