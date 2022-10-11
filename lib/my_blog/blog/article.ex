defmodule MyBlog.Blog.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyBlog.Blog.{Tag, ArticleTag}

  schema "articles" do
    field :category, :string
    field :cover_image, :string
    field :description, :string
    field :is_published, :boolean, default: false
    field :slug, :string
    field :title, :string
    field :tag, :string, virtual: true
    belongs_to :user, MyBlog.Account.User

    many_to_many(:tags, Tag,
      join_through: ArticleTag,
      on_replace: :delete,
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :category, :cover_image, :tag])
    |> validate_required([:title, :description, :category])
    |> generate_slug()
    |> unique_constraint(:slug)
  end

  def generate_slug(changeset) do
    title = get_change(changeset, :title)

    if title do
      slug = title |> String.split(" ", trim: true) |> Enum.join("-") |> String.downcase()
      put_change(changeset, :slug, slug)
    else
      changeset
    end
  end
end
