defmodule MyBlogWeb.IndexLive do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog

  def mount(_params, _session, socket) do
    articles = Blog.list_articles()
    {:ok, assign(socket, articles: articles)}
  end
end
