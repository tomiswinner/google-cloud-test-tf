

locals {
  load_balancing_scheme = "EXTERNAL_MANAGED"
}


module "frontend" {
  source = "./modules/frontend"
  rsc_prefix = var.rsc_prefix
  region = var.region
  enable_public_access = true 
}

module "load-balancer" {
  source = "./modules/load-balancer"
  rsc_prefix = var.rsc_prefix
  region = var.region
  load_balancing_scheme = local.load_balancing_scheme
  backend_bucket_name = module.frontend.bucket_name
  backend_service_name = google_cloud_run_service.backend.name
}


