output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "function_app_name" {
  value = azurerm_windows_function_app.main.name
}

output "function_app_url" {
  value = "https://${azurerm_windows_function_app.main.default_hostname}"
}

