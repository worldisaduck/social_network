defmodule SocialNetwork.Repo.Migrations.CreateProfilesTable do
  use Ecto.Migration

  def change do
		create table(:profiles) do
			add :first_name, :string
			add :surname, :string
			add :patronymic, :string
			add :date_of_birth, :date
			add :gender, :string
			add :city_of_origin, :string
			add :city_of_living, :string
			add :info, :text
			add :user_id, references(:users)

			timestamps()
		end
  end
end
