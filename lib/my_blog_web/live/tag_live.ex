defmodule MyBlogWeb.TagLive do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog

  def mount(_params, _session, socket) do
    tags = Blog.list_tags()
    {:ok, assign(socket, tags: tags)}
  end
end
