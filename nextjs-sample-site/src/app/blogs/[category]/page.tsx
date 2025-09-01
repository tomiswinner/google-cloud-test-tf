export const dynamic = "force-static";

export async function generateStaticParams() {
  const categories = ["tech", "life"];

  return categories.map((category) => ({
    category: category,
  }));
}

export default function CategoryPage({
  params,
}: {
  params: { category: string };
}) {
  const categoryPosts = {
    tech: [
      { post: "nextjs-ssg", title: "Next.js SSG入門" },
      { post: "typescript-tips", title: "TypeScript Tips" },
    ],
    life: [
      { post: "daily-update", title: "今日の出来事" },
      { post: "weekend-activity", title: "週末の活動" },
    ],
  };

  const posts =
    categoryPosts[params.category as keyof typeof categoryPosts] || [];

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">{params.category} カテゴリ</h1>
      <div className="space-y-4">
        {posts.map((post) => (
          <div key={post.post} className="border p-4 rounded">
            <h2 className="text-xl font-semibold">
              <a
                href={`/blogs/${params.category}/${post.post}`}
                className="text-blue-600 hover:underline"
              >
                {post.title}
              </a>
            </h2>
          </div>
        ))}
      </div>
      <a
        href="/blogs"
        className="text-blue-600 hover:underline mt-6 inline-block"
      >
        ← ブログ一覧に戻る
      </a>
    </div>
  );
}
