# Front — ローカル起動方法（簡易）

前提:

- Node.js（推奨 v16 / v18）がインストールされていること

コマンド:

```bash
cd front
# 依存をインストール
npm ci || npm install

# TypeScript をビルド
npm run build

# サーバ起動（デフォルト: http://localhost:3000）
npm start
```

Docker で起動する場合:

```bash
# イメージ名: tak-cors-test-front
docker build -t tak-cors-test-front:local .
docker run -p 3000:3000 tak-cors-test-front:local
```

簡単な確認:

- ブラウザで `http://localhost:3000` を開き、バックエンド欄に `http://localhost:8080` を入れて「Ping」してみてください。
- ローカルでの CORS 動作確認には、フロントとバックでポート（またはホスト名）を分けることが重要です。
