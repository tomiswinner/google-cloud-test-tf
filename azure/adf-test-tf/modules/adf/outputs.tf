output "id" {
  description = "ID of the Data Factory"
  value       = azurerm_data_factory.this.id
}

output "name" {
  description = "Name of the Data Factory"
  value       = azurerm_data_factory.this.name
}

output "linked_service_names" {
  description = "Names of the linked services"
  value       = [for ls in azurerm_data_factory_linked_custom_service.this : ls.name]
}

