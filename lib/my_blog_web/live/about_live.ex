defmodule MyBlogWeb.AboutLive do
  use MyBlogWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
