import Link from "next/link";

export const dynamic = "force-static";

export default function BlogsPage() {
  const blogs = [
    {
      category: "tech",
      post: "nextjs-ssg",
      title: "Next.js SSG入門",
      excerpt: "Next.jsでの静的サイト生成について...",
    },
    {
      category: "tech",
      post: "typescript-tips",
      title: "TypeScript Tips",
      excerpt: "TypeScriptの便利な使い方...",
    },
    {
      category: "life",
      post: "daily-update",
      title: "今日の出来事",
      excerpt: "今日あったこと...",
    },
    {
      category: "life",
      post: "weekend-activity",
      title: "週末の活動",
      excerpt: "週末にやったこと...",
    },
  ];

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Blog Posts</h1>
      <div className="space-y-4">
        {blogs.map((blog) => (
          <div key={blog.post} className="border p-4 rounded">
            <div className="mb-2">
              <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded text-sm">
                {blog.category}
              </span>
            </div>
            <h2 className="text-xl font-semibold mb-2">
              <Link
                href={`/blogs/${blog.category}/${blog.post}`}
                className="text-blue-600 hover:underline"
              >
                {blog.title}
              </Link>
            </h2>
            <p className="text-gray-600">{blog.excerpt}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
