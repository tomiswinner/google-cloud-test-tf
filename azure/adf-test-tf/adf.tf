# # Azure Data Factory
# resource "azurerm_data_factory" "adf" {
#   name                = "adf-test-${random_string.suffix.result}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
# }

# # Integration Runtime (Azure)
# resource "azurerm_data_factory_integration_runtime_azure" "ir" {
#   name            = "ir-azure-test"
#   data_factory_id = azurerm_data_factory.adf.id
#   location        = azurerm_resource_group.rg.location
# }

# # Linked Service - Blob Storage
# resource "azurerm_data_factory_linked_service_azure_blob_storage" "blob" {
#   name              = "ls-blob-storage"
#   data_factory_id   = azurerm_data_factory.adf.id
#   connection_string = azurerm_storage_account.storage.primary_connection_string
# }

# # Dataset - Input CSV
# resource "azurerm_data_factory_dataset_delimited_text" "input" {
#   name                = "ds-input-csv"
#   data_factory_id     = azurerm_data_factory.adf.id
#   linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.blob.name

#   azure_blob_storage_location {
#     container = azurerm_storage_container.input.name
#     filename  = "input.csv"
#   }

#   column_delimiter      = ","
#   row_delimiter         = "\n"
#   first_row_as_header   = true
#   quote_character       = "\""
#   escape_character      = "\\"
# }

# # Dataset - Output CSV
# resource "azurerm_data_factory_dataset_delimited_text" "output" {
#   name                = "ds-output-csv"
#   data_factory_id     = azurerm_data_factory.adf.id
#   linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.blob.name

#   azure_blob_storage_location {
#     container = azurerm_storage_container.output.name
#     filename  = "output.csv"
#   }

#   column_delimiter      = ","
#   row_delimiter         = "\n"
#   first_row_as_header   = true
#   quote_character       = "\""
#   escape_character      = "\\"
# }

# # Data Flow
# resource "azurerm_data_factory_data_flow" "dataflow" {
#   name            = "df-copy-transform"
#   data_factory_id = azurerm_data_factory.adf.id

#   source {
#     name = "source1"
#     dataset {
#       name = azurerm_data_factory_dataset_delimited_text.input.name
#     }
#   }

#   sink {
#     name = "sink1"
#     dataset {
#       name = azurerm_data_factory_dataset_delimited_text.output.name
#     }
#   }

#   script = <<EOT
# source(output(
#     col1 as string,
#     col2 as string
#   ),
#   allowSchemaDrift: true,
#   validateSchema: false) ~> source1
# source1 sink(allowSchemaDrift: true,
#   validateSchema: false) ~> sink1
# EOT
# }

# # Pipeline
# resource "azurerm_data_factory_pipeline" "pipeline" {
#   name            = "pl-test-copy"
#   data_factory_id = azurerm_data_factory.adf.id

#   activities_json = jsonencode([
#     {
#       name = "DataFlowActivity"
#       type = "ExecuteDataFlow"
#       typeProperties = {
#         dataFlow = {
#           referenceName = azurerm_data_factory_data_flow.dataflow.name
#           type          = "DataFlowReference"
#         }
#         integrationRuntime = {
#           referenceName = azurerm_data_factory_integration_runtime_azure.ir.name
#           type          = "IntegrationRuntimeReference"
#         }
#       }
#     }
#   ])
# }

