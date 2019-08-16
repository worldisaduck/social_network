defmodule SocialNetwork.Accounts.User do
	use Ecto.Schema
	import Ecto.Changeset

	schema "users" do
		field :encrypted_password, :string
		field :username, :string

		field :password, :string, virtual: true
		field :password_confirmation, :string, virtual: true

		timestamps()
	end

	@doc false
	def changeset(user, attrs) do
		user
		|> cast(attrs, [:username, :password, :password_confirmation])
		|> validate_required([:username, :password, :password_confirmation])
		|> validate_length(:password, min: 6)
		|> validate_confirmation(:password)
		|> unique_constraint(:username)
		|> hash_password
	end

	defp hash_password(changeset) do
		case changeset do
			%Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
				put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(pass))
			_ ->
				changeset
		end
	end
end
