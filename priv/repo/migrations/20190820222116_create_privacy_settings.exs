defmodule SocialNetwork.Repo.Migrations.CreatePrivacySettings do
  use Ecto.Migration

  def change do
		create table(:privacy_settings) do
			add :profile_id, references(:profiles)
			add :profile_type, :string
			add :photo_albums, :string
			add :posts, :string
			add :groups, :string
			add :comments, :string
			add :send_messages, :string
			add :friends, :string
			add :friend_request, :string
		end
  end
end
