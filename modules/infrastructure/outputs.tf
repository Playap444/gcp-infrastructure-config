output "main_vpc_network" {
  value = google_compute_network.main_vpc_network.id
}
output "gke_subnetwork" {
  value = google_compute_subnetwork.gke.id
}