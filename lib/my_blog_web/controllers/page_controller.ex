defmodule MyBlogWeb.PageController do
  use MyBlogWeb, :controller

  alias MyBlog.Blog.Article
  alias MyBlog.Blog

  def new(conn, _params) do
    changeset = Article.changeset(%Article{}, %{})
    render(conn, "form.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case Blog.create_article(article_params) do
      {:ok, article} ->
        conn |> redirect(to: "/blog/#{article.slug}")

      {:error, changeset} ->
        render(conn, "form.html", changeset: changeset)
    end
  end

  def list(conn, _params) do
    articles = Blog.list_articles()
    IO.inspect(articles)
    render(conn, "articles.html", articles: articles)
  end
end
