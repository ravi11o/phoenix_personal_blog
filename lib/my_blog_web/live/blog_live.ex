defmodule MyBlogWeb.BlogLive do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog

  def mount(_params, _session, socket) do
    articles = Blog.list_articles()
    {:ok, assign(socket, articles: articles)}
  end

  def handle_params(%{"search" => term}, _, socket) do
    articles = Blog.search_results(term)

    {:noreply, assign(socket, articles: articles)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def handle_event("search-article", %{"search" => ""}, socket) do
    {:noreply, push_patch(socket, to: "/blog")}
  end

  def handle_event("search-article", %{"search" => term}, socket) do
    {:noreply, push_patch(socket, to: "/blog?search=#{term}")}
  end
end
