terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }
  
  backend "gcs" {
      bucket = "alev-tf-state"
      prefix = "terraform/state"
  }

  required_version = "~> 0.15"
}

