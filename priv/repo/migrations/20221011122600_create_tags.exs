defmodule MyBlog.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add(:name, :string)

      timestamps()
    end

    create(index(:tags, ["lower(name)"], name: :tags_name_index, unique: true))

    create table(:articles_tags) do
      add(:article_id, references(:articles, on_delete: :delete_all))
      add(:tag_id, references(:tags, on_delete: :delete_all))
      timestamps()
    end

    create(index(:articles_tags, [:article_id]))
    create(index(:articles_tags, [:tag_id]))
    create(unique_index(:articles_tags, [:article_id, :tag_id]))
  end
end
