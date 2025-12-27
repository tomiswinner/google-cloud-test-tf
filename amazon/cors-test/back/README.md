# Back — ローカル起動方法（簡易）

前提:

- Node.js がインストールされているか、Docker を使えること

コマンド:

```bash
cd back
npm install
npm run build
npm start

# または Docker を使う場合
docker build -t tak-cors-test-back:local .
docker run -p 8080:8080 tak-cors-test-back:local
```

エンドポイント:

- GET /api/ping — JSON で {"status":"ok"} を返します（CORS ヘッダ付き）

CORS 確認（curl 例）:

```bash
# プリフライト（OPTIONS）
curl -i -X OPTIONS -H "Origin: http://localhost:3000" -H "Access-Control-Request-Method: GET" http://localhost:8080/api/ping

# 実リクエスト
curl -i -H "Origin: http://localhost:3000" http://localhost:8080/api/ping
```

CORS 設定:

- `src/index.ts` の `CORS_ENABLED` を `false` にすると CORS ヘッダーを返さない（拒否）
