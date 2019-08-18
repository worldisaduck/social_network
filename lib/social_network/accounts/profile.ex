defmodule SocialNetwork.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

	schema "profiles" do
		field :firs_name, :string
		field :surname, :string
		field :patronymic, :string
		field :date_of_birh, :date
		field :gender, :string
		field :city_of_origin, :string
		field :city_of_living, :string
		field :info, :string
		belongs_to :user, SocialNetwork.Accounts.User

		timestamps()	
	end
end
