defmodule MyBlogWeb.ArticleFormLive do
  use MyBlogWeb, :live_view

  alias MyBlog.Blog.Article

  def mount(_params, _session, socket) do
    changeset = Article.changeset(%Article{}, %{})
    {:ok, assign(socket, changeset: changeset, trigger_submit: false)}
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
end
