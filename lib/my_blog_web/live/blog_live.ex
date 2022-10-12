defmodule MyBlogWeb.BlogLive do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog

  def mount(_params, _session, socket) do
    total = Blog.count_articles()
    {:ok, assign(socket, count: total, search: "")}
  end

  def handle_params(%{"search" => term} = params, _, socket) do
    options = create_options(params)
    total = Blog.search_results(term)
    articles = Blog.search_results(term, options.page, options.per_page)


    {:noreply, assign(socket, articles: articles, count: total, options: options, search: term)}
  end

  def handle_params(params, _, socket) do
    options = create_options(params)
    articles = Blog.list_articles(options.page, options.per_page)

    {:noreply, assign(socket, articles: articles, options: options)}
  end

  def handle_event("search-article", %{"search" => ""}, socket) do
    options = socket.assigns.options
    {:noreply, push_patch(socket, to: "/blog?page=#{options.page}&per_page=#{options.per_page}")}
  end

  def handle_event("search-article", %{"search" => term}, socket) do
    {:noreply, push_patch(socket, to: "/blog?search=#{term}")}
  end

  defp create_options(params) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    %{page: page, per_page: per_page}
  end
end
