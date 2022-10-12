defmodule MyBlog.Blog do
  import Ecto.Query, warn: false
  alias MyBlog.Repo

  alias MyBlog.Blog.{Article, Tag}

  def list_articles do
    Article
    |> preload(:tags)
    |> order_by(desc: :inserted_at)
    |> limit(5)
    |> Repo.all()
  end

  def list_articles(page, per_page) do
    Article
    |> preload(:tags)
    |> order_by(desc: :inserted_at)
    |> limit(^per_page)
    |> offset(^per_page * (^page - 1))
    |> Repo.all()
  end

  def count_articles do
    Article |> Repo.aggregate(:count)
  end

  def get_article(id) do
    Repo.get!(Article, id) |> Repo.preload(:tags)
  end

  def get_article_by_slug(slug) do
    Article
    |> where([a], a.slug == ^slug)
    |> preload(:tags)
    |> Repo.one()
  end

  def create_article(params) do
    %Article{}
    |> Repo.preload(:tags)
    |> Article.changeset(params)
    |> Ecto.Changeset.put_assoc(:tags, article_tags(params))
    |> Repo.insert()
  end

  def update_article(article, params) do
    article
    |> Repo.preload(:tags)
    |> Article.changeset(params)
    |> Ecto.Changeset.put_assoc(:tags, article_tags(params))
    |> Repo.update()
  end

  def delete_article(id) do
    article = get_article(id)
    Repo.delete!(article)
  end

  defp parse_tags(nil), do: []

  defp parse_tags(tags) do
    # Repo.insert_all requires the inserted_at and updated_at to be filled out
    # and they should have time truncated to the second that is why we need this
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    for tag <- String.split(tags, ","),
        tag = tag |> String.trim() |> String.downcase(),
        tag != "",
        do: %{name: tag, inserted_at: now, updated_at: now}
  end

  defp article_tags(attrs) do
    # => [%{name: "phone", inserted_at: ..},  ...]
    tags = parse_tags(attrs["tag"])

    # do an upsert ensuring that all the input tags are present
    Repo.insert_all(Tag, tags, on_conflict: :nothing)

    tag_names = for t <- tags, do: t.name
    # find all the input tags
    Repo.all(from(t in Tag, where: t.name in ^tag_names))
  end

  ######### Tags router

  def list_tags do
    Repo.all(Tag) |> Repo.preload(:articles)
  end

  def get_tag(name) do
    Tag
    |> preload(articles: [:tags])
    |> Repo.get_by!(name: name)
  end

  ##### Text based search
  defp prefix_search(term), do: String.replace(term, ~r/\W/u, "") <> ":*"

  defp search(query, search_term) do
    where(
      query,
      fragment(
        "to_tsvector('english', title || ' ' || description) @@
        to_tsquery(?)",
        ^prefix_search(search_term)
      )
    )
  end

  # def search_results(term, page, per_page) do
  #   Article
  #   |> search(term)
  #   |> preload(:tags)
  #   |> limit(^per_page)
  #   |> offset(^per_page * (^page - 1))
  #   |> Repo.all()
  # end

  defp search_query(term) do
    Article
    |> search(term)
    |> preload(:tags)
  end

  def search_results(term, page, per_page) do
    search_query(term)
    |> limit(^per_page)
    |> offset(^per_page * (^page - 1))
    |> Repo.all()
  end

  def search_results(term) do
    search_query(term)
    |> Repo.aggregate(:count)
  end
end
