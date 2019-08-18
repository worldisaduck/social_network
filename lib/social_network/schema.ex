defmodule SocialNetwork.Schema do
	use Absinthe.Schema
	alias SocialNetwork.Accounts
	require IEx

	query do
		field :all_users, list_of(:user) do
			resolve &Accounts.list_users/2
		end
	end

	mutation do
		field :sign_up, :user do
			arg :username, non_null(:string)
			arg :password, non_null(:string)
			arg :password_confirmation, non_null(:string)

			resolve fn args, _ ->
				{:ok, SocialNetwork.Accounts.User |> SocialNetwork.Repo.all |> List.first}
			end
		end
	end

	object :user do
		field :id, :id
		field :username, :string
		field :password, :string
		field :password_confirmation, :string
	end
end
