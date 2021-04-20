variable "project_id" {
  description = "alevz-project-1-310308"
}

variable "region" {
  description = "asia-southeast2"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
#  secondary_ip_range {
#      range_name    = "pod"
#      ip_cidr_range = "10.20.0.0/23"
#  }
#  secondary_ip_range {
#      range_name    = "svc"
#      ip_cidr_range = "10.30.0.0/23"
#  }

}
