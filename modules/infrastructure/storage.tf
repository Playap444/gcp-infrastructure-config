resource "google_storage_bucket" "main-storage" {
  project                  = var.project_default
  name                     = "test-store-${var.environment}"
  location                 = var.location
  force_destroy            = true
  # public_access_prevention = "enforced"
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://test-store-${var.environment}.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}