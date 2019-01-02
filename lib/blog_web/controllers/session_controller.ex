defmodule BlogWeb.SessionController do
  use BlogWeb, :controller
  alias Blog.Account
  alias Blog.Account.User

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def new(conn, _params) do
    changeset = Account.login_form(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    Account.get_by_username(user_params["username"])
    |> sign_in(user_params["password"], conn)
  end

  def delete(conn, _params) do
  conn
  |> delete_session(:current_user)
  |> put_flash(:info, "Signed out successfully!")
  |> redirect(to: Routes.page_path(conn, :index))
end


  defp sign_in(user, _password, conn) when is_nil(user) do
    failed_login(conn)
  end

  defp sign_in(user, password, conn) do
    if checkpw(password, user.password_digest) do
      conn
      |> put_session(:current_user, %{id: user.id, username: user.username})
      |> put_flash(:info, "Sign in successful!")
      |> redirect(to: Routes.post_path(conn, :index))
    else
      failed_login(conn)

    end
  end

  defp failed_login(conn) do
    dummy_checkpw()
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:error, "Invalid username/password combination!")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

end
