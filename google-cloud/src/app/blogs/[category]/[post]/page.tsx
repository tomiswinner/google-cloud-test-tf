import Link from "next/link";

export const dynamic = "force-static";

export async function generateStaticParams() {
  const posts = [
    { category: "tech", post: "nextjs-ssg" },
    { category: "tech", post: "typescript-tips" },
    { category: "life", post: "daily-update" },
    { category: "life", post: "weekend-activity" },
  ];

  return posts.map((item) => ({
    category: item.category,
    post: item.post,
  }));
}

export default function CategoryBlogPost({
  params,
}: {
  params: { category: string; post: string };
}) {
  const postData = {
    "nextjs-ssg": {
      title: "Next.js SSG入門",
      content: "Next.jsでの静的サイト生成について...",
    },
    "typescript-tips": {
      title: "TypeScript Tips",
      content: "TypeScriptの便利な使い方...",
    },
    "daily-update": { title: "今日の出来事", content: "今日あったこと..." },
    "weekend-activity": { title: "週末の活動", content: "週末にやったこと..." },
  };

  const post = postData[params.post as keyof typeof postData];

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="mb-4">
        <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded text-sm">
          {params.category}
        </span>
      </div>
      <h1 className="text-3xl font-bold mb-4">{post.title}</h1>
      <p className="text-lg">{post.content}</p>
      <div className="mt-6 space-x-4">
        <Link href="/blogs" className="text-blue-600 hover:underline">
          ← ブログ一覧
        </Link>
        <Link
          href={`/blogs/${params.category}`}
          className="text-blue-600 hover:underline"
        >
          ← {params.category}カテゴリ一覧
        </Link>
      </div>
    </div>
  );
}
