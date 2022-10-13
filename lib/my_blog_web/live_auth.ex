defmodule MyBlogWeb.LiveAuth do
  import Phoenix.LiveView

  alias MyBlog.Account
  alias MyBlog.Account.User

  def on_mount(:admin, _, session, socket) do
    socket = assign_current_user(session, socket)

    case socket.assigns.current_user do
      nil ->
        {:halt,
         socket
         |> put_flash(:error, "You are not authorized for this action")
         |> redirect(to: "/")}

      %User{is_admin: true} ->
        {:cont, socket}
    end
  end

  def on_mount(:user, _, session, socket) do
    socket = assign_current_user(session, socket)

    case socket.assigns.current_user do
      nil ->
        {:halt,
         socket
         |> put_flash(:error, "You are not authorized for this action")
         |> redirect(to: "/")}

      %User{} ->
        {:cont, socket}
    end
  end

  defp assign_current_user(session, socket) do
    case session do
      %{"user_token" => user_token} ->
        assign_new(socket, :current_user, fn ->
          Account.get_user_by_session_token(user_token)
        end)

      %{} ->
        assign_new(socket, :current_user, fn -> nil end)
    end
  end
end
