defmodule SocialNetwork.Repo.Migrations.CreateFriends do
  use Ecto.Migration

  def change do
    create table(:friends, primary_key: false) do
      add :first_user_id, :integer, null: false
      add :second_user_id, :integer, null: false
      add :state, :string, null: false

      timestamps()
    end

    create index(:friends, [:first_user_id, :second_user_id])
  end
end
