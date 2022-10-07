defmodule MyBlogWeb.DetailsLive do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog

  def mount(%{"slug" => slug}, _session, socket) do
    article = Blog.get_article_by_slug(slug)
    {:ok, assign(socket, article: article)}
  end
end
