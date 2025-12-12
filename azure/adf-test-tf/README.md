## import tes
- 自分で terraform コードを以下のように書いた上で、import 
- [参照](https://dev.classmethod.jp/articles/terraform-import-command-and-import-block/)

```hcl
# storage account
resource "azurerm_storage_account" "target" {
}
```

- import コマンドを実行

```bash
terraform import azurerm_storage_account.storage /subscriptions/<SUB_ID>/resourceGroups/rg-adf-test/providers/Microsoft.Storage/storageAccounts/<STORAGE_NAME>
```


## v1.5 以上の場合取り込み

```hcl
import {
  to = azurerm_storage_account.target
  id = "/subscriptions/{SUB_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Storage/storageAccounts/{STORAGE_NAME}"
}
```

```bash
terraform plan -generate-config-out=generated_resources.tf
```
