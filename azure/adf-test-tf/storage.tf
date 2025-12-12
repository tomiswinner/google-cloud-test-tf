# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "stadftestdata${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Blob Containers
resource "azurerm_storage_container" "input" {
  name                  = "input"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "output" {
  name                  = "output"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}


# import test
# import {
#   to = azurerm_storage_account.target # target = terraform リソース名となる
#   id = "/subscriptions/fcf6dedb-c06b-41f1-8344-1c008ca4b872/resourceGroups/rg-adf-test/providers/Microsoft.Storage/storageAccounts/taktaktaktaktest22"
# }



# resource "azurerm_storage_account" "target" {
#   access_tier                       = "Hot"
#   account_kind                      = "StorageV2"
#   account_replication_type          = "RAGRS"
#   account_tier                      = "Standard"
#   allow_nested_items_to_be_public   = false
#   allowed_copy_scope                = null
#   cross_tenant_replication_enabled  = false
#   default_to_oauth_authentication   = false
#   dns_endpoint_type                 = "Standard"
#   edge_zone                         = null
#   https_traffic_only_enabled        = true
#   infrastructure_encryption_enabled = false
#   is_hns_enabled                    = false
#   large_file_share_enabled          = true
#   location                          = "japaneast"
#   name                              = "taktaktaktaktest22"
#   nfsv3_enabled                     = false
#   public_network_access_enabled     = true
#   resource_group_name               = "rg-adf-test"
#   sftp_enabled                      = false
#   shared_access_key_enabled         = true
#   table_encryption_key_type         = "Service"
#   tags                              = {}
#   blob_properties {
#     change_feed_enabled           = false
#     default_service_version       = null
#     last_access_time_enabled      = false
#     versioning_enabled            = false
#     container_delete_retention_policy {
#       days = 7
#     }
#     delete_retention_policy {
#       days                     = 7
#       permanent_delete_enabled = false
#     }
#   }
#   queue_properties {
#     hour_metrics {
#       enabled               = false
#       include_apis          = false
#       version               = "1.0"
#     }
#     logging {
#       delete                = false
#       read                  = false
#       version               = "1.0"
#       write                 = false
#     }
#     minute_metrics {
#       enabled               = false
#       include_apis          = false
#       version               = "1.0"
#     }
#   }
#   share_properties {
#     retention_policy {
#       days = 7
#     }
#   }
# }
