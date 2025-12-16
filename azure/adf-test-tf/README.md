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


## v1.5 以上の場合取り込み(普通はこっち)

```hcl
import {
  to = azurerm_storage_account.target
  id = "/subscriptions/{SUB_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Storage/storageAccounts/{STORAGE_NAME}"
}
```

```bash
terraform plan -generate-config-out=generated_resources.tf
```

- ↑で生成されたコードを main.tf などの対象の場所に追記し、tf plan をして、 import 文を消せば良い

# module への import の場合

- module への import の場合、自動生成は root module に対してしかできないので、root に対して自動生成した後に自分で `terraform import` を実行する
- [参考](https://www.ntt-tx.co.jp/column/iac/240123/)

- 以下を一旦書いて、root module に対してコードを自動生成

```hcl
import {
  to = azurerm_storage_account.target
  id = "/subscriptions/{SUB_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Storage/storageAccounts/{STORAGE_NAME}"
}
```

- ↑で生成されたコードを module に記述する

- 最後に、module に設定して自前で `import` を記述(`terraform init` 必要かも)

```hcl
import {
  to = module.hello.azurerm_storage_account.target
  id = "/subscriptions/{SUB_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Storage/storageAccounts/{STORAGE_NAME}"
}
```


