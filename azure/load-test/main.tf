# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.pj_name}-rg-loadtest"
  location = var.location

  tags = {
    Project    = var.pj_name
    ManagedBy  = "terraform"
  }
}

# Azure Load Testing Service
resource "azurerm_load_test_service" "main" {
  name                = "${var.pj_name}-loadtest"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = {
    Project    = var.pj_name
    ManagedBy  = "terraform"
  }
}

