module "main_infra" {
  source = "./modules/infrastructure"

  environment     = var.environment
  product         = var.product
  project_default = data.google_project.default.name

  # NETWORK #
  subnet001_cidr_range        = var.subnet001_cidr_range
  snet_backend_ip_cidr_range  = var.snet_backend_ip_cidr_range
  snet_frontend_ip_cidr_range = var.snet_frontend_ip_cidr_range
  snet_gke_ip_cidr_range      = var.snet_gke_ip_cidr_range

}

# module "identity" {
#   source = "./modules/identity"

# }

# module "app_storage" {
#   source = "./modules/storage"

# }

module "gke_test" {
  source = "./modules/gke"

  environment = var.environment
  product     = var.product
  project_id  = var.project_id

  ### NETWORK ### 
  main_vpc_network = module.main_infra.main_vpc_network
  gke_subnetwork   = module.main_infra.gke_subnetwork
}