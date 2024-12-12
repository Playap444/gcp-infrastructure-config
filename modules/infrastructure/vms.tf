resource "google_service_account" "default" {
  project      = var.project_default
  account_id   = "sa-test-${var.environment}"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  project      = var.project_default
  name         = "vm-test-${var.environment}"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  tags = ["${var.environment}"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  # metadata = {
  #   foo = "bar"
  # }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

# # instance template
# resource "google_compute_instance_template" "default" {
#   name         = "l7-xlb-mig-template"
#   provider     = google-beta
#   machine_type = "e2-small"
#   tags         = ["allow-health-check"]

#   network_interface {
#     network    = google_compute_network.default.id
#     subnetwork = google_compute_subnetwork.default.id
#     access_config {
#       # add external ip to fetch packages
#     }
#   }
#   disk {
#     source_image = "debian-cloud/debian-12"
#     auto_delete  = true
#     boot         = true
#   }

#   # install nginx and serve a simple web page
#   metadata = {
#     startup-script = <<-EOF1
#       #! /bin/bash
#       set -euo pipefail

#       export DEBIAN_FRONTEND=noninteractive
#       apt-get update
#       apt-get install -y nginx-light jq

#       NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
#       IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
#       METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')

#       cat <<EOF > /var/www/html/index.html
#       <pre>
#       Name: $NAME
#       IP: $IP
#       Metadata: $METADATA
#       </pre>
#       EOF
#     EOF1
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # MIG
# resource "google_compute_instance_group_manager" "default" {
#   name     = "l7-xlb-mig1"
#   provider = google-beta
#   zone     = "us-central1-c"
#   named_port {
#     name = "http"
#     port = 8080
#   }
#   version {
#     instance_template = google_compute_instance_template.default.id
#     name              = "primary"
#   }
#   base_instance_name = "vm"
#   target_size        = 2
# }