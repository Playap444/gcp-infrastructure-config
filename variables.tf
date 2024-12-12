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
variable "subnet001_cidr_range" {
  type = string
}
variable "snet_frontend_ip_cidr_range" {
  type = string
}
variable "snet_backend_ip_cidr_range" {
  type = string
}