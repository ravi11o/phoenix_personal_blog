defmodule MyBlog.Blog do
  import Ecto.Query, warn: false
  alias MyBlog.Repo

  alias MyBlog.Blog.Article

  def list_articles do
    Article
    |> Repo.all()
  end

  def get_article_by_slug(slug) do
    Article
    |> where([a], a.slug == ^slug)
    |> Repo.one()
  end

  def create_article(params) do
    changeset = Article.changeset(%Article{}, params)
    IO.inspect(changeset)
    Repo.insert(changeset)
  end
end
