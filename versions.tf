terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.66.1"
    }
  }
  
  backend "gcs" {
      bucket = "alevz-demo-tf-demo-1"
      prefix = "terraform/state"
  }

  required_version = "~> 0.15"
}

