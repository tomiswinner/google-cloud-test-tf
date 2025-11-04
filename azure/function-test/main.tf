# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.pj_name}-rg"
  location = var.location

  tags = {
    Project     = var.pj_name
  }
}

# Storage Account for Durable Functions
resource "azurerm_storage_account" "main" {
  name                     = "${var.pj_name}stg"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Project     = var.pj_name
  }
}

# App Service Plan (Premium)
resource "azurerm_service_plan" "main" {
  name                = "${var.pj_name}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Windows"
  sku_name            = "EP1"

  tags = {
    Project     = var.pj_name
  }
}

# Function App
resource "azurerm_windows_function_app" "main" {
  name                = "${var.pj_name}-func"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  service_plan_id            = azurerm_service_plan.main.id

  site_config {
    application_stack {
      dotnet_version = "v8.0"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated"
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  tags = {
    Project     = var.pj_name
  }
}
