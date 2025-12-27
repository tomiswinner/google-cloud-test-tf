variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-access-rest-func"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "japaneast"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique)"
  type        = string
  default     = "staccessrestfunc"
}

variable "function_app_name" {
  description = "Name of the function app"
  type        = string
  default     = "func-access-rest"
}

