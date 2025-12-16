variable "name" {
  description = "Name of the Function App"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "ip_restrictions" {
  description = "List of IP restrictions for the Function App"
  type = list(object({
    name        = string
    service_tag = optional(string)
    ip_address  = optional(string)
    priority    = number
    action      = string
  }))
  default = []
}

