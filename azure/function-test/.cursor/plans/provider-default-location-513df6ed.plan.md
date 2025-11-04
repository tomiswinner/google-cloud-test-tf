<!-- 513df6ed-1f4c-4a78-98ff-bdfdf2bc3fca 68f1bfc4-4763-42b7-9b43-14753d7e6f24 -->
# Provider に default_location を設定

## 変更内容

1. **provider.tf** (11-13行目)

- `azurerm` provider に `default_location = var.location` を追加

2. **main.tf**

- リソースグループ (4行目): `location = var.location` を削除
- 他のリソース (15, 28, 41行目): `location = azurerm_resource_group.main.location` はそのまま維持（リソースグループから継承）

## 結果

Provider レベルでデフォルトロケーションを設定することで、明示的に指定しない限り全リソースがそのロケーションを使用します。`variables.tf` の location 変数は維持され、引き続き柔軟に変更可能です。