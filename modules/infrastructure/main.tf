# resource "google_project" "default_project" {
#   name       = "project-${var.product}-${var.environment}-001"
#   project_id = "project-id-${var.product}-${var.environment}"
#   org_id     = "1313131"
# }
# resource "random_string" "bucket_suffix" {
#   length  = 8
#   special = false
#   upper   = false
# }