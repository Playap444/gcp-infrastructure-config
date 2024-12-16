resource "google_storage_bucket" "main-storage" {
  project       = var.project_default
  name          = "stg-${var.environment}-${random_string.bucket_suffix.result}"
  location      = var.location
  force_destroy = true
  # public_access_prevention = "enforced"
  uniform_bucket_level_access = true
  storage_class = "STANDARD"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  retention_policy {
    retention_period = 300
  }

  lifecycle_rule {
    condition {
      age = 31
    }
    action {
      type = "Delete"
      storage_class = "ARCHIVE"
    }
  }

  cors {
    origin          = ["http://stg-${var.environment}-${random_string.bucket_suffix.result}.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_object" "test_picture" {
  name   = "test-object-picture"
  source = "../../img/test_obj.jpg"
  bucket = google_storage_bucket.main-storage.name
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.main-storage.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.main-storage.name
  role   = "READER"
  entity = "allUsers"
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}