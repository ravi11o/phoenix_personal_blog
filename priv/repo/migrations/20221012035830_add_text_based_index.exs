defmodule MyBlog.Repo.Migrations.AddTextBasedIndex do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION pg_trgm")

    execute("""
    CREATE INDEX articles_trgm_idx ON articles USING GIN (to_tsvector('english',
      title || ' ' || description))
    """)
  end
end
