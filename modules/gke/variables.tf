variable "environment" {
  type = string
}
variable "location" {
  type    = string
  default = "us-central1"
}
variable "product" {
  type = string
}
variable "project_id" {
  type = string
}

### NETWORK ###
variable "main_vpc_network" {
  type = string
}
variable "gke_subnetwork" {
  type = string
}