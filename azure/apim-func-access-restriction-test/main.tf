# Load IP restrictions from JSON file
locals {
  ip_restrictions = jsondecode(file("${path.module}/ip_restrictions.json"))
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Function App Module
module "function_app" {
  source = "./modules/function_app"

  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  ip_restrictions     = local.ip_restrictions
}

# API Management
resource "azurerm_api_management" "main" {
  name                = var.apim_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = "Consumption_0"
}

# API in APIM that points to Function App
resource "azurerm_api_management_api" "func_api" {
  name                = "function-api"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Function API"
  path                = "func"
  protocols           = ["https"]
  service_url         = "https://${module.function_app.default_hostname}/api"
}

# API Operation example
resource "azurerm_api_management_api_operation" "hello" {
  operation_id        = "hello"
  api_name            = azurerm_api_management_api.func_api.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = azurerm_resource_group.main.name
  display_name        = "Hello"
  method              = "GET"
  url_template        = "/hello"
}
