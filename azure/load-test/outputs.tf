output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "load_test_name" {
  description = "Name of the Load Test"
  value       = azurerm_load_test.main.name
}

output "load_test_id" {
  description = "ID of the Load Test"
  value       = azurerm_load_test.main.id
}

output "load_test_data_plane_uri" {
  description = "Data plane URI of the Load Test"
  value       = azurerm_load_test.main.data_plane_uri
}

