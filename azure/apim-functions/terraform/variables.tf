variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "taktaktak-test001-rg"

}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "japaneast"
}

variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
  default     = "taktaktak-test001-func"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique)"
  type        = string
  default     = "taktaktaktest001sa"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "taktaktak-test001-asp"
}

variable "dotnet_version" {
  description = ".NET version for the Function App"
  type        = string
  default     = "v8.0"
}

variable "zip_deploy_file" {
  description = "Path to the ZIP file for deployment (optional)"
  type        = string
  default     = "./helloWorld.zip"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

