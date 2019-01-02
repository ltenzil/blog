defmodule Blog.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blog.Account.User


  schema "posts" do
    field :body, :string
    field :title, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
  end
end
