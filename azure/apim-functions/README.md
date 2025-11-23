## デプロイ方法

Makefile を使用して Azure Function App にデプロイできます。

### 基本的な使い方

```bash
# デフォルト値でデプロイ（helloWorld ディレクトリ、az-di-dev-jpe-func-taktest-002-single-get）
make deploy

# ディレクトリ名と Function App 名を指定
make deploy DIR=helloWorld APP_NAME=my-function-app

# リソースグループも指定
make deploy DIR=helloWorld APP_NAME=my-function-app RESOURCE_GROUP=my-resource-group
```

### 利用可能なターゲット

- `make deploy` - ビルド、パブリッシュ、ZIP作成、デプロイを一括実行
- `make publish` - ビルド、パブリッシュ、ZIP作成まで実行
- `make build` - プロジェクトをビルド
- `make clean` - ビルド成果物を削除
- `make help` - ヘルプを表示

### デフォルト値

- `DIR=helloWorld`
- `APP_NAME=az-di-dev-jpe-func-taktest-002-single-get`
- `RESOURCE_GROUP=az-di-rg-if-catalog-test`
