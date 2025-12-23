variable "name" {
  description = "Name of the Data Factory"
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

variable "linked_services" {
  description = "List of custom linked services"
  type = list(object({
    name            = string
    type            = string
    type_properties = map(any)
    parameters      = optional(map(string), {})
  }))
  default = []
}

