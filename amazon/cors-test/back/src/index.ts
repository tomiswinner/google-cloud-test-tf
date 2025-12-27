import express, { Request, Response } from "express";

const app = express();
const port = Number(process.env.PORT || 8080);

// JSON ボディのパース
app.use(
  express.json(),
  (req, res, next) => {
    console.log(`${req.method} ${req.url}`);
    next();
  }
);

// CORS設定: 環境変数 CORS_ENABLED=true/false
const CORS_ENABLED: boolean = process.env.CORS_ENABLED === "true" ? true : false;

function setCorsHeaders(req: Request, res: Response) {
  if (!CORS_ENABLED) return;

  const origin = req.headers.origin || "*";
  res.setHeader("Access-Control-Allow-Origin", origin);
  res.setHeader("Access-Control-Allow-Methods", "GET,POST,PUT,PATCH,DELETE,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
}

// メモリ上のデータストア
interface Item {
  id: number;
  name: string;
  value?: string;
}
let items: Item[] = [
  { id: 1, name: "item1", value: "foo" },
  { id: 2, name: "item2", value: "bar" },
];
let nextId = 3;

// プリフライト (OPTIONS) - 全エンドポイント
app.options("/api/*", (req, res) => {
  setCorsHeaders(req, res);
  res.status(204).end();
});

// GET /api/ping
app.get("/api/ping", (req, res) => {
  setCorsHeaders(req, res);
  res.json({ status: "ok" });
});

// GET /api/items - 全件取得
app.get("/api/items", (req, res) => {
  setCorsHeaders(req, res);
  res.json(items);
});

// GET /api/items/:id - 1件取得
app.get("/api/items/:id", (req, res) => {
  setCorsHeaders(req, res);
  const item = items.find((i) => i.id === Number(req.params.id));
  if (!item) {
    res.status(404).json({ error: "not found" });
    return;
  }
  res.json(item);
});

// POST /api/items - 新規作成
app.post("/api/items", (req, res) => {
  setCorsHeaders(req, res);
  const { name, value } = req.body;
  const item: Item = { id: nextId++, name, value };
  items.push(item);
  res.status(201).json(item);
});

// PUT /api/items/:id - 全置換
app.put("/api/items/:id", (req, res) => {
  setCorsHeaders(req, res);
  const idx = items.findIndex((i) => i.id === Number(req.params.id));
  if (idx === -1) {
    res.status(404).json({ error: "not found" });
    return;
  }
  const { name, value } = req.body;
  items[idx] = { id: items[idx].id, name, value };
  res.json(items[idx]);
});

// PATCH /api/items/:id - 部分更新
app.patch("/api/items/:id", (req, res) => {
  setCorsHeaders(req, res);
  const idx = items.findIndex((i) => i.id === Number(req.params.id));
  if (idx === -1) {
    res.status(404).json({ error: "not found" });
    return;
  }
  items[idx] = { ...items[idx], ...req.body };
  res.json(items[idx]);
});

// DELETE /api/items/:id - 削除
app.delete("/api/items/:id", (req, res) => {
  setCorsHeaders(req, res);
  const idx = items.findIndex((i) => i.id === Number(req.params.id));
  if (idx === -1) {
    res.status(404).json({ error: "not found" });
    return;
  }
  const deleted = items.splice(idx, 1)[0];
  res.json(deleted);
});

app.listen(port, () => {
  console.log(`Back running at http://0.0.0.0:${port}`);
});
