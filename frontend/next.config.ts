import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* 
  standalone : コンテナ用の build 設定
  .next/standalone 配下に build され, 最低限の node.js にまとめてくれる
   */
  output: "standalone",
};

export default nextConfig;
