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

# # Azure Storage Account からソースファイルをダウンロード（オプション）
# data "external" "download_from_storage" {
#   count = var.source_storage_account_name != "" && var.source_container_name != "" && var.source_blob_name != "" ? 1 : 0

#   program = ["bash", "${path.module}/scripts/download_blob.sh"]

#   query = {
#     storage_account = var.source_storage_account_name
#     container       = var.source_container_name
#     blob            = var.source_blob_name
#     output_dir      = "${path.root}/.terraform/downloaded"
#   }
# }

# # ソースファイルのパス（リモートからダウンロードした場合とローカルの場合）
# locals {
#   source_file = var.source_storage_account_name != "" && var.source_container_name != "" && var.source_blob_name != "" ? data.external.download_from_storage[0].result.file_path : var.app
# }

data "archive_file" "app_hash" {
  # This just exists to get the hash of the app.zip file.
  type        = "zip"
  source_file = var.app
  output_path = "${path.root}/.terraform/archive_files/app.zip"
}

# data "archive_file" "app" {
#   type        = "zip"
#   source_file = var.app
#   output_path = "${path.root}/.terraform/archive_files/app-${data.archive_file.app_hash.output_sha256}.zip"
# }

resource "terraform_data" "app" {
  triggers_replace = [
    data.archive_file.app_hash.output_sha256
  ]
  provisioner "local-exec" {
    command = "cp ${var.app} ${path.root}/.terraform/archive_files/app-${data.archive_file.app_hash.output_sha256}.zip"
  }
}
# null resource はもう使われないので、terraform_data を使う
# resource "null_resource" "app" {
#   triggers = {
#     app_hash = data.archive_file.app_hash.output_sha256
#   }
#   provisioner "local-exec" {
#     command = "cp ${var.app} ${path.root}/.terraform/archive_files/app-${data.archive_file.app_hash.output_sha256}.zip"
#   }
# }


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
  name                = "${var.function_app_name}-yo"
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

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }

  zip_deploy_file = "${path.root}/.terraform/archive_files/app-${data.archive_file.app_hash.output_sha256}.zip"
  # zip_deploy_file = data.archive_file.app.output_path

  tags = var.tags
  depends_on = [terraform_data.app]
}

