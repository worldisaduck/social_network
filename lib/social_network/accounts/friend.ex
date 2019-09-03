defmodule SocialNetwork.Accounts.Friend do
  use Ecto.Schema
  import Ecto.Changeset
  alias SocialNetwork.Accounts.User

  @primary_key false
  schema "friends" do
    belongs_to :first_user, User, foreign_key: :first_user_id
    belongs_to :second_user, User, foreign_key: :second_user_id
    field :state, :string

    timestamps()
  end

  def changeset(friends, params) do
    friends
    |> cast(params, [:first_user_id, :second_user_id, :state])
  end
end
