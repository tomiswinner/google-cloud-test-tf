module "frontend" {
  source = "../modules/frontend"
  rsc_prefix = var.rsc_prefix
  region = var.region
  enable_public_access = false
}

module "load-balancer" {
  source = "../modules/load-balancer"
  rsc_prefix = var.rsc_prefix
  region = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend_bucket_name = module.frontend.bucket_name
  backend_service_name = module.frontend.backend_service_name
}
