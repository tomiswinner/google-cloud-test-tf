# マルチステージビルド
# frontend/Dockerfile
# 各種ステージのベースとなるベースイメージ
FROM node:18-alpine AS base

# 依存関係インストール専用ステージ
## package.json(依存関係) が変更がなければ、ここはずっとキャッシュされるので build と deps を分ける
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json* ./
## npm ci は lock ファイルを更新しない安全なインストール
RUN npm ci 

# ビルド専用ステージ
## アプリコードが変わるたびにここは再実行される
FROM base AS builder
WORKDIR /app
## 依存関係インストール専用ステージから node_modules をコピー
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# テレメトリ無効化
ENV NEXT_TELEMETRY_DISABLED 1

RUN npm run build

# 本番用イメージ
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

# セキュリティ的に、コンテナは root で動かさないのがベストプラクティス。
# そのため、コンテナ内では非 root ユーザーを作成し、そのユーザーでアプリケーションを実行する。
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

# .next ディレクトリを作成し、nextjs ユーザーに所有権を付与。
# Next.js がサーバーサイドで prerender キャッシュ を書き込むときに必要。
RUN mkdir .next
RUN chown nextjs:nodejs .next

# ビルド専用ステージから .next/standalone をコピー
# ビルド専用ステージから .next/static をコピー
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000

# バグのため↓のコマンドにする
# https://qiita.com/uesho/items/36271b5a576e70650c7e
CMD ["node", "server.js"]
# CMD HOSTNAME="0.0.0.0" node server.js

