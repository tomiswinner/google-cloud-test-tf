variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-apim-func-test"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "japaneast"
}

variable "apim_name" {
  description = "Name of the API Management instance"
  type        = string
  default     = "apim-func-test22"
}

variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
  default     = "func-apim-test-taktaktak"
}

variable "apim_publisher_name" {
  description = "Publisher name for APIM"
  type        = string
  default     = "Test Publisher"
}

variable "apim_publisher_email" {
  description = "Publisher email for APIM"
  type        = string
  default     = "admin@example.com"
}

