defmodule MyBlogWeb.ArticleFormLive do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog.Article
  alias MyBlog.Blog

  def mount(params, _session, socket) do
    article =
      case params["id"] do
        nil -> nil
        id -> Blog.get_article(id)
      end

    changeset =
      case article do
        nil -> Article.changeset(%Article{}, %{})
        %Article{} = article -> Article.changeset(article, %{})
      end

    {:ok,
     assign(socket,
       changeset: changeset,
       article: article,
       id: params["id"],
       trigger_submit: false
     )}
  end

  def handle_event("save", %{"article" => params}, socket) do
    # uploads =
    #   consume_uploaded_entries(socket, :image, fn meta, entry ->
    #     dest = Path.join("priv/static/images", filename(entry))
    #     File.cp!(meta.path, dest)
    #     Routes.static_path(socket, "/images/#{filename(entry)}")
    #   end)

    # [image_url] =
    #   consume_uploaded_entries(socket, :image, fn meta, _ ->
    #     case Cloudex.upload(meta.path) do
    #       {:ok, file} -> file.secure_url
    #       {:error, _} -> nil
    #     end
    #   end)

    changeset = Article.changeset(%Article{}, params)

    {:noreply, assign(socket, changeset: changeset, trigger_submit: changeset.valid?)}
  end

  def handle_event("update", %{"article" => params}, socket) do
    article = Blog.get_article(socket.assigns.id)
    # uploads =
    #   consume_uploaded_entries(socket, :image, fn meta, entry ->
    #     dest = Path.join("priv/static/images", filename(entry))
    #     File.cp!(meta.path, dest)
    #     Routes.static_path(socket, "/images/#{filename(entry)}")
    #   end)

    # [image_url] =
    #   consume_uploaded_entries(socket, :image, fn meta, _ ->
    #     case Cloudex.upload(meta.path) do
    #       {:ok, file} -> file.secure_url
    #       {:error, _} -> nil
    #     end
    #   end)

    case Blog.update_article(article, params) do
      {:ok, article} -> {:noreply, push_redirect(socket, to: "/blog/#{article.slug}")}
      {:error, changeset} -> {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
