# Azure Durable Functions 最小構成セットアップ

## 実装内容

### 1. provider.tf の設定

Azure RM プロバイダーの基本設定を追加

### 2. main.tf の実装

以下のリソースを作成：

- Resource Group (Japan East)
- Storage Account (Durable Functions に必要)
- App Service Plan (Premium プラン)
- Function App (Durable Functions 拡張機能を有効化)

### 3. variables.tf の作成

- プロジェクト名
- リージョン
- 環境名などの変数定義

### 4. outputs.tf の作成

- Function App 名
- Function App の URL
- ストレージアカウント名などを出力

## 主要設定

- リージョン: Japan East
- App Service Plan: Premium (EP1)
- ランタイム: .NET 8.0 isolated
- Durable Functions 拡張機能を有効化

### To-dos

- [x] provider.tf に Azure RM プロバイダーの設定を追加
- [x] main.tf にリソースグループ、ストレージアカウント、App Service Plan、Function App を定義
- [x] variables.tf に変数定義を作成
- [x] outputs.tf に出力値を定義

## 完了状況

すべてのタスクが完了しました。Azure Durable Functions の最小構成が`/azure/function-test/`ディレクトリに作成されています。
