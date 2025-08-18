variable "rsc_prefix" {
  type = string
  description = "Resource prefix"
}

variable "region" {
  type = string
  description = "Region"
} 

variable "load_balancing_scheme" {
  type = string
  description = "Load balancing scheme"
}

variable "backend_bucket_name" {
  type = string
  description = "Backend bucket name"
}

variable "backend_service_name" {
  type = string
  description = "Backend service name"
}
