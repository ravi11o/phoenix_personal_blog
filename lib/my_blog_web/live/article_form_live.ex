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

    socket =
      allow_upload(
        socket,
        :cover,
        accept: ~w(.png .jpg .jpeg),
        max_file_size: 5_000_000
      )

    {:ok,
     assign(socket,
       changeset: changeset,
       article: article,
       article_id: params["id"]
     )}
  end

  def handle_event("save", %{"article" => params}, socket) do
    [image] =
      consume_uploaded_entries(socket, :cover, fn meta, _entry ->
        case Cloudex.upload(meta.path) do
          {:ok, file} -> file.secure_url
          {:error, _} -> nil
        end
      end)

    params = %{params | "cover_image" => image}

    case Blog.create_article(params) do
      {:ok, article} -> {:noreply, push_redirect(socket, to: "/blog/#{article.slug}")}
      {:error, changeset} -> {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("validate", %{"article" => params}, socket) do
    changeset = Article.changeset(%Article{}, params)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("update", %{"article" => params}, socket) do
    article = Blog.get_article(socket.assigns.article_id)

    uploaded =
      consume_uploaded_entries(socket, :cover, fn meta, _entry ->
        case Cloudex.upload(meta.path) do
          {:ok, file} -> file.secure_url
          {:error, _} -> nil
        end
      end)

    image =
      case uploaded do
        [] -> nil
        [image] -> image
      end

    params = %{params | "cover_image" => image || article.cover_image}

    case Blog.update_article(article, params) do
      {:ok, article} -> {:noreply, push_redirect(socket, to: "/blog/#{article.slug}")}
      {:error, changeset} -> {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
