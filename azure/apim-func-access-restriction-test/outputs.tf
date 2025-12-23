# output "function_app_url" {
#   description = "URL of the Function App"
#   value       = "https://${module.function_app.default_hostname}"
# }

# output "apim_gateway_url" {
#   description = "Gateway URL of the API Management"
#   value       = azurerm_api_management.main.gateway_url
# }

# output "apim_api_url" {
#   description = "URL to access Function via APIM"
#   value       = "${azurerm_api_management.main.gateway_url}/func/hello"
# }

# output "apim_ip_addresses" {
#   description = "IP addresses of the API Management"
#   value       = azurerm_api_management.main.public_ip_addresses
# }
