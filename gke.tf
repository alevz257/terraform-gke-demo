variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 3
  description = "number of gke nodes"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone
  project  = var.project_id

  provider = google-beta

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  private_cluster_config {
    enable_private_endpoint = "false"
    enable_private_nodes = "true"
    master_ipv4_cidr_block = "10.100.0.0/28"
  }

  master_authorized_networks_config {
      cidr_blocks {
          cidr_block   = "0.0.0.0/0"
          display_name = "all-for-testing"
      }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.11.0.0/20"
    services_ipv4_cidr_block = "10.12.0.0/23"
  }


  addons_config {
    istio_config {
      disabled  = false
      auth      = "AUTH_MUTUAL_TLS"
    }
  }

#  master_auth {
#    username = var.gke_username
#    password = var.gke_password

#    client_certificate_config {
#      issue_client_certificate = false
#    }
#  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-4"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

#GKE Autopilot
resource "google_container_cluster" "autopilot" {
  name          = "${var.project_id}-gke-autopilot"
  location      = var.region
  enable_autopilot = "true"
  project       = var.project_id

  network       = google_compute_network.vpc.name
  subnetwork    = google_compute_subnetwork.subnet.name
  
  private_cluster_config {
    enable_private_endpoint = "false"
    enable_private_nodes    = "true"
    master_ipv4_cidr_block  = "10.101.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block    = "0.0.0.0/0"
      display_name  = "all-for-testing"
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block   = "10.13.0.0/20"
    services_ipv4_cidr_block  = "10.14.0.0/23"
  }
}



# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }
