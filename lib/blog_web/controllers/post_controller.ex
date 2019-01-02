defmodule BlogWeb.PostController do
  use BlogWeb, :controller
  alias Blog.CMS
  alias Blog.CMS.Post

  plug(
    BlogWeb.Sessions.WebRequireUser
    when action in [:new, :create, :edit, :update, :delete]
  )
  #plug :assign_user

  def index(conn, _params) do
    posts = CMS.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = CMS.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case CMS.create_post(current_user(conn), post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = CMS.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = CMS.get_post!(id)
    changeset = CMS.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = CMS.get_post!(id)

    case CMS.update_post(post, current_user(conn), post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = CMS.get_post!(id)
    {:ok, _post} = CMS.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  # defp assign_user(conn, _opts) do
  #   case conn.params do
  #     %{"user_id" => user_id} ->
  #       user = Account.get_user!(user_id)
  #       assign(conn, :user, user)
  #     _ ->
  #       conn
  #   end
  # end
end
