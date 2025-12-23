resource "azurerm_data_factory" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_data_factory_linked_custom_service" "this" {
  for_each = { for ls in var.linked_services : ls.name => ls }

  name                 = each.value.name
  data_factory_id      = azurerm_data_factory.this.id
  type                 = each.value.type
  type_properties_json = jsonencode(each.value.type_properties)
  parameters           = lookup(each.value, "parameters", null)
}

