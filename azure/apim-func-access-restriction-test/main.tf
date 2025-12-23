# Load IP restrictions from JSON file
locals {
  ip_restrictions = concat(
    jsondecode(file("${path.module}/ip_restrictions.json")),
    # [for ip in azurerm_api_management.main.public_ip_addresses : {
    [for ip in ["10.0.0.4","10.0.0.5"] : {
      name       = "APIM"
      ip_address = "${ip}/32"
      action     = "Allow"
      priority   = 100
    }]
  )
}

# # Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# # Function App Module
module "function_app" {
  source = "./modules/function_app"

  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  ip_restrictions     = local.ip_restrictions
}

# # # API Management
# resource "azurerm_api_management" "main" {
#   name                = var.apim_name
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   publisher_name      = var.apim_publisher_name
#   publisher_email     = var.apim_publisher_email
#   sku_name            = "Developer_1"
# }
