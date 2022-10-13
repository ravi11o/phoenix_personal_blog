defmodule MyBlogWeb.ArticleLive do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog

  def mount(_params, _session, socket) do
    articles = Blog.list_articles()
    {:ok, assign(socket, articles: articles)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    Blog.delete_article(id)

    {:noreply,
     socket
     |> put_flash(:info, "Article deleted")
     |> push_redirect(to: "/articles")}
  end

  def handle_event("publish", %{"id" => id}, socket) do
    article = Blog.get_article(id)

    case Blog.update_article(article, %{is_published: !article.is_published}) do
      {:ok, _article} ->
        {:noreply, push_redirect(socket, to: "/articles")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Something went wrong")
         |> push_redirect(to: "/articles")}
    end

    {:noreply, socket}
  end
end
