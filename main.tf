module "main_infra" {
  source = "./modules/infrastructure"

  environment     = var.environment
  product         = var.product
  project_default = data.google_project.default.name

  # NETWORK #
  subnet001_cidr_range        = var.subnet001_cidr_range
  snet_backend_ip_cidr_range  = var.snet_backend_ip_cidr_range
  snet_frontend_ip_cidr_range = var.snet_frontend_ip_cidr_range

}

# module "identity" {
#   source = "./modules/identity"

# }

# module "app_storage" {
#   source = "./modules/storage"

# }