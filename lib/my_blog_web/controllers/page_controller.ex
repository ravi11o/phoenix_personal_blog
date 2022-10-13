defmodule MyBlogWeb.PageController do
  use MyBlogWeb, :controller

  # alias MyBlog.Blog.Article
  # alias MyBlog.Blog

  # def new(conn, _params) do
  #   changeset = Article.changeset(%Article{}, %{})
  #   render(conn, "form.html", changeset: changeset)
  # end

  # def create(conn, %{"article" => article_params}) do
  #   case Blog.create_article(article_params) do
  #     {:ok, article} ->
  #       conn |> redirect(to: "/blog/#{article.slug}")

  #     {:error, changeset} ->
  #       render(conn, "form.html", changeset: changeset)
  #   end
  # end

  # def list(conn, _params) do
  #   articles = Blog.list_articles()
  #   render(conn, "articles.html", articles: articles)
  # end

  # def delete(conn, %{"id" => id}) do
  #   Blog.delete_article(id)
  #   redirect(conn, to: "/articles")
  # end

  # def edit(conn, %{"id" => id}) do
  #   article = Blog.get_article(id)
  #   changeset = Article.changeset(%Article{} = article, %{})
  #   render(conn, "form.html", changeset: changeset, article: article)
  # end

  # def update(conn, %{"id" => id, "article" => article_params}) do
  #   article = Blog.get_article(id)

  #   case Blog.update_article(article, article_params) do
  #     {:ok, article} ->
  #       conn |> redirect(to: "/blog/#{article.slug}")

  #     {:error, changeset} ->
  #       render(conn, "form.html", changeset: changeset, article: article)
  #   end
  # end

  def not_found(conn, _) do
    render(conn, "404.html")
  end
end
