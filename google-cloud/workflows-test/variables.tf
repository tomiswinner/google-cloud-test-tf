variable "project_id" {
  description = "The ID of the GCP project"
  type = string
  validation {
    condition = length(var.project_id) > 0
    error_message = "The project_id must be a non-empty string."
  }
}

variable "region" {
  description = "The region to deploy resources to"
  type = string
  default = "asia-northeast1"
}

variable "rsc_prefix" {
  description = "The prefix to add to the resource names"
  type = string
  default = "taktak-static"
}

