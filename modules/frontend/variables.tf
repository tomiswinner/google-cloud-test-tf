variable "rsc_prefix" {
  type = string
  description = "Resource prefix"
}

variable "region" {
  type = string
  description = "Region"
}


variable "enable_public_access" {
  description = "Enable public access to the bucket"
  type        = bool
  default     = false
}
