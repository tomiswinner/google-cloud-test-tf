```bash
# template の確認
dotnet new list

# 1. 基本の Functions プロジェクトを作成
dotnet new func --name function-app

# 2. Durable Functions の NuGet パッケージを追加
cd function-app
dotnet add package Microsoft.Azure.Functions.Worker.Extensions.DurableTask

```
