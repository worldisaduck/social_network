defmodule SocialNetwork.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
		create table(:photos) do
			add :profile_id, references(:profiles)
			add :album, :string

			timestamps()
		end
  end
end
