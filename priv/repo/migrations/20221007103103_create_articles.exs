defmodule MyBlog.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :description, :text
      add :category, :string
      add :is_published, :boolean, default: false, null: false
      add :slug, :string
      add :cover_image, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:articles, [:slug])
    create index(:articles, [:user_id])
  end
end
