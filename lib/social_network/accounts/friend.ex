defmodule SocialNetwork.Accounts.Friend do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friends" do
    field :first_user_id, :integer
    field :second_user_id, :integer
    field :action, :integer, default: 1

    timestamps()
  end

  def changeset(friends, params) do
    friends
    |> cast(params, [:first_user_id, :second_user_id, :action])
  end
end
