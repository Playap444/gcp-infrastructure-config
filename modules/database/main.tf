resource "google_spanner_instance" "main" {
  project      = var.project_id
  config       = "regional-europe-west1"
  display_name = "spanner-instance-${var.environment}"
  num_nodes    = 1
}

resource "google_spanner_database" "db1" {
  project                  = var.project_id
  instance                 = google_spanner_instance.main.name
  name                     = "db-${var.product}-${var.environment}"
  version_retention_period = "3d"
  ddl = [
    <<-EOT
    CREATE TABLE sneaker_sheet (
      sneaker_brand STRING(100),
      sneaker_model STRING(100),
      sneaker_year  STRING(100),
    ) PRIMARY KEY (sneaker_brand)
    EOT
  ]
  deletion_protection = false
}
