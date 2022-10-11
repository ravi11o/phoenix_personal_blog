defmodule MyBlog.Blog.ArticleTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles_tags" do
    belongs_to(:article, MyBlog.Blog.Article)
    belongs_to(:tag, MyBlog.Blog.Tag)

    timestamps()
  end

  @doc false
  def changeset(article_tag, attrs) do
    article_tag
    |> cast(attrs, [:article_id, :tag_id])
    |> validate_required([:article_id, :tag_id])
  end
end
