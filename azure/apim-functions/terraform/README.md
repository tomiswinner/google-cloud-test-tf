# Terraform for Azure Functions App (Windows, .NET)

このディレクトリには、Windows上で.NET関数アプリを作成するためのTerraform構成が含まれています。

## 使用方法

1. `terraform.tfvars.example` を `terraform.tfvars` にコピーして編集：

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. `terraform.tfvars` を編集して、リソース名や設定を変更します。

3. Terraformを初期化：

```bash
terraform init
```

4. 実行計画を確認：

```bash
terraform plan
```

5. リソースを作成：

```bash
terraform apply
```

6. リソースを削除：

```bash
terraform destroy
```

## 変数

- `resource_group_name`: リソースグループ名
- `location`: Azureリージョン（デフォルト: japaneast）
- `function_app_name`: 関数アプリ名
- `storage_account_name`: ストレージアカウント名（グローバルで一意、小文字、英数字のみ）
- `app_service_plan_name`: App Service Plan名
- `sku_name`: SKU名（デフォルト: Y1 = Consumption Plan）
- `sku_tier`: SKU階層（デフォルト: Dynamic）
- `dotnet_version`: .NETバージョン（デフォルト: v8.0）
- `tags`: リソースに適用するタグ

## 注意事項

- `storage_account_name` はグローバルで一意である必要があります（小文字、英数字のみ、3-24文字）
- `function_app_name` もグローバルで一意である必要があります

