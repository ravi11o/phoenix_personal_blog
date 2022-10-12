defmodule MyBlogWeb.TaggedArticle do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog

  def mount(%{"name" => name}, _session, socket) do
    tag = Blog.get_tag(name)
    {:ok, assign(socket, tag: tag)}
  end
end
