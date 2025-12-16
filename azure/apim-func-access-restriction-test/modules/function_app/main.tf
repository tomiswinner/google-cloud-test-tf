# Storage Account for Function App
resource "azurerm_storage_account" "this" {
  name                     = replace("${var.name}sa", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# App Service Plan for Function App
resource "azurerm_service_plan" "this" {
  name                = "${var.name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Function App
resource "azurerm_linux_function_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key
  service_plan_id            = azurerm_service_plan.this.id

  site_config {
    application_stack {
      node_version = "18"
    }

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        name        = ip_restriction.value.name
        service_tag = ip_restriction.value.service_tag
        ip_address  = ip_restriction.value.ip_address
        priority    = ip_restriction.value.priority
        action      = ip_restriction.value.action
      }
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
  }
}

