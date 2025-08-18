

locals {
  load_balancing_scheme = "EXTERNAL_MANAGED"
}


module "load-balancer" {
  source = "./modules/load-balancer"
  rsc_prefix = var.rsc_prefix
  region = var.region
  load_balancing_scheme = local.load_balancing_scheme
  backend_bucket_name = google_storage_bucket.static-website.name
  backend_service_name = google_cloud_run_service.backend.name
}


