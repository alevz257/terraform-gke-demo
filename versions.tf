terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }
  
  backend "gcs" {
      bucket = "alevz-demo-tf-1"
      prefix = "terraform/state"
  }

  required_version = "~> 0.15"
}

