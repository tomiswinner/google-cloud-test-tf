## 概要

```bash
# 開発用
npm run dev

# 本番用 build : .netx 配下に build される
npm run build

# ローカルで本番起動 : .next 配下を公開する
npm run start
```

- 以下の config を設定することで、 npm run build 時に、完全 SSG ビルドが行われ, `out` 配下に build される

```ts:next.config.ts
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
};

export default nextConfig;
```

## out ファイルについて

- `index.html` などはそのまま

## http-server について

- 静的ホストを簡単にローカルホストできる
  - `GET`に対してデフォルトで`index.html`を返す
    - `index.html` が存在しない場合は、ディレクトリ一覧を返す
  - 存在しないファイルなら`404.html`を返す

```bash
# カレントディレクトリを公開
npx http-server

# out 配下を公開する
npx http-server out
```

## App Router

- path で route を管理する
- [slug] で動的パスが使える

## Link について

- next では<a></a>は非推奨（ブラウザのフルロードが走るので）
- Link コンポーネントを利用する(こうすると、next/router が動いてくれる)

### 内部ルーター

