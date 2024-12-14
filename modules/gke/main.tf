# resource "google_service_account" "default" {
#   account_id   = "service-account-id"
#   display_name = "Service Account"
# }

resource "google_container_cluster" "primary" {
  project    = var.project_id
  name       = "test-cluster"
  location   = var.location
  network    = var.main_vpc_network
  subnetwork = var.gke_subnetwork
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "memory"
      minimum       = "1"
      maximum       = "10"
    }

    resource_limits {
      resource_type = "cpu"
      minimum       = "1"
      maximum       = "10"
    }
  }
  node_locations = ["us-central1-b"]

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_node1" {
  project = var.project_id
  name    = "my-node-pool"
  location   = var.location
  cluster        = google_container_cluster.primary.name
  node_count     = 1
  node_locations = ["us-central1-c", "us-central1-b"]


  autoscaling {
    max_node_count = 2
    min_node_count = 1
  }

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 10

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# resource "google_container_node_pool" "primary_node2" {
#   project = var.project_id
#   name       = "my-node-pool"
# #   location   = "us-central1"
#   cluster    = google_container_cluster.primary.name
#   node_count = 1
#   node_locations = [ "us-central1-c", "us-central1-b" ]

#   node_config {
#     preemptible  = true
#     machine_type = "e2-medium"
#     disk_size_gb = "10GB"

#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     service_account = google_service_account.default.email
#     oauth_scopes    = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }
