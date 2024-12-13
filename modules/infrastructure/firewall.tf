resource "google_compute_firewall" "main" {
  project       = var.project_default
  name          = "acg-firewall"
  network       = google_compute_network.main_vpc_network.name
  description   = "Creates firewall rule targeting tagged instances"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  #   source_tags = ["foo"]
  #   target_tags = ["web"]
}