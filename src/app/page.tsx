import Link from "next/link";

export default function Home() {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-8">
        Welcome to Next.js Sample Site
      </h1>

      <nav className="mb-8">
        <h2 className="text-2xl font-semibold mb-4">Pages:</h2>
        <div className="space-y-2">
          <Link href="/about" className="block text-blue-600 hover:underline">
            About
          </Link>
          <Link href="/contact" className="block text-blue-600 hover:underline">
            Contact
          </Link>
          <Link href="/blogs" className="block text-blue-600 hover:underline">
            Blogs
          </Link>
        </div>
      </nav>

      <p>これはSSGで作成されたサンプルサイトです。</p>
    </div>
  );
}
