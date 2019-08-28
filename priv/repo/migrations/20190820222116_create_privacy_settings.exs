defmodule SocialNetwork.Repo.Migrations.CreatePrivacySettings do
  use Ecto.Migration

  def change do
		create table(:privacy_settings) do
			add :profile_id, references(:profiles)
			add :profile_type, :string, default: "public"
			add :photo_albums, :string, default: "everyone"
			add :posts, :string, default: "everyone"
			add :groups, :string, default: "everyone"
			add :comments, :string, default: "everyone"
			add :send_messages, :string, default: "everyone"
			add :friends, :string, default: "everyone"
			add :friend_request, :string, default: "everyone"

			timestamps()
		end
  end
end
