
# Configure the Google Cloud Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# もしかしたらこれ必要かも
# provider "google-beta" {
#   project = var.project_id
#   region  = var.region
# }
