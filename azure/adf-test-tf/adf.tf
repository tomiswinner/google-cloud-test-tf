module "adf" {
  source = "./modules/adf"

  name                = "adf-test-001-takta"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  linked_services = [
    {
      name = "ls-custom-rest-api-1"
      type = "RestService"
      type_properties = {
        url                 = "https://api.example1.com"
        enableServerCertificateValidation = true
        authenticationType  = "Anonymous"
      }
    },
    {
      name = "ls-custom-rest-api-2"
      type = "RestService"
      type_properties = {
        url                 = "https://api.example2.com"
        enableServerCertificateValidation = true
        authenticationType  = "Anonymous"
      }
    }
  ]
}
