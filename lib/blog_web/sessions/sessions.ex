defmodule BlogWeb.Sessions do
  @moduledoc """
  The Session context.
  """

  import Ecto.Query, warn: false
  alias Blog.Account


  def current_user(%{assigns: %{current_user: u}}), do: u

  def current_user(conn) do
    case get_current_user(conn) do
      nil ->
        nil
      user ->
        Account.get_user!(user.id)
    end
  end

  def logged_in?(conn), do: !!current_user(conn)

  defp get_current_user(conn) do
    if get_session_from_cookies() do
      case conn.cookies["current_user"] do
        nil -> Plug.Conn.get_session(conn, :current_user)
        u -> u
      end
    else
      Plug.Conn.get_session(conn, :current_user)
    end
  end

  defp get_session_from_cookies() do
    Application.get_env(:blog, :get_session_from_cookies) || false
  end
end
