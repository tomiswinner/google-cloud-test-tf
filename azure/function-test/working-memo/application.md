<!-- 513df6ed-1f4c-4a78-98ff-bdfdf2bc3fca 5414d604-e2c1-48c8-afbd-faf059d8ddbc -->

# Azure Durable Functions Hello World API の作成

## 実装する構成

以下の 3 つの関数を含む C# プロジェクトを作成します:

1. **HTTP Trigger** (`HelloWorldHttpStart.cs`) - エントリーポイント

   - HTTP リクエストを受け付け、オーケストレーションを開始

2. **Orchestrator** (`HelloWorldOrchestrator.cs`) - オーケストレータ

   - アクティビティ関数を呼び出し、結果を返却

3. **Activity** (`HelloWorldActivity.cs`) - アクティビティ関数

   - "Hello World" メッセージを生成

## 作成するファイル

### プロジェクトディレクトリ: `function-app/`

1. **function-app/function-app.csproj**

   - .NET 8.0 の Isolated Worker プロジェクト
   - 必要な NuGet パッケージ:
     - `Microsoft.Azure.Functions.Worker`
     - `Microsoft.Azure.Functions.Worker.Sdk`
     - `Microsoft.Azure.Functions.Worker.Extensions.DurableTask`
     - `Microsoft.Azure.Functions.Worker.Extensions.Http`

2. **function-app/Program.cs**

   - Host の設定とエントリーポイント

3. **function-app/host.json**

   - Functions ランタイムの設定

4. **function-app/local.settings.json**

   - ローカル開発用の設定

5. **function-app/HelloWorldHttpStart.cs**

   - HTTP トリガー関数
   - エンドポイント: `GET/POST /api/HelloWorld`

6. **function-app/HelloWorldOrchestrator.cs**

   - オーケストレータ関数
   - アクティビティ `SayHello` を呼び出し

7. **function-app/HelloWorldActivity.cs**

   - アクティビティ関数 `SayHello`
   - "Hello World!" メッセージを返す

8. **function-app/.gitignore**

   - C# プロジェクト用の .gitignore

## デプロイ方法

作成後、Azure Functions Core Tools または VS Code の Azure Functions 拡張機能を使用してデプロイします:

```bash
cd function-app
func azure functionapp publish taktaktaktf-func
```

## API の使い方

デプロイ後、以下の URL にアクセス:

- `https://taktaktaktf-func.azurewebsites.net/api/HelloWorld`

レスポンスには、オーケストレーションのステータス確認 URL が含まれます。

### To-dos

- [x] function-app.csproj を作成 (NuGet パッケージ参照を含む)
- [x] Program.cs を作成 (Host 設定)
- [x] host.json と local.settings.json を作成
- [x] HelloWorldActivity.cs を作成 (Hello World を生成)
- [x] HelloWorldOrchestrator.cs を作成 (アクティビティを呼び出し)
- [x] HelloWorldHttpStart.cs を作成 (HTTP エントリーポイント)
- [x] .gitignore を作成
