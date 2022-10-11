defmodule MyBlog.Blog.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyBlog.Blog.{Article, ArticleTag}

  schema "tags" do
    field(:name, :string)
    many_to_many(:articles, Article, join_through: ArticleTag, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
