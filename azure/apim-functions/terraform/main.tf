terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Zip で更新をかける方法
variable "app" {
  type = string
  default = "./helloWorld.zip"
}
data "archive_file" "app_hash" {
  # This just exists to get the hash of the app.zip file.
  type        = "zip"
  source_file  = var.app
  output_path = "${path.module}/.terraform/archive_files/app.zip"
}
data "archive_file" "app" {
  type        = "zip"
  source_file  = var.app
  output_path = "${path.module}/.terraform/archive_files/app-${data.archive_file.app_hash.output_sha256}.zip"
}



# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Storage Account (required for Function App)
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# App Service Plan (Windows, Premium)
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Windows"
  sku_name            = "EP1"
  tags                = var.tags
}

# Function App (Windows, .NET)
resource "azurerm_windows_function_app" "main" {
  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key

  site_config {
    application_stack {
      dotnet_version              = var.dotnet_version
      use_dotnet_isolated_runtime = true
    }
  }

  zip_deploy_file = data.archive_file.app.output_path

  tags = var.tags
}

