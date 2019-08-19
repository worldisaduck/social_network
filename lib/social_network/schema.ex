defmodule SocialNetwork.Schema do
	use Absinthe.Schema
	alias SocialNetwork.Accounts
	alias SocialNetwork.Auth
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

			resolve fn params, _ ->
				with {:ok, user} <- Accounts.create_user(params),
						 {:ok, user} <- Auth.encode_and_sign(user) do
					{:ok, user}
				else
					{:error, error} ->
						{:error, ["errors", "more errors"]} 
				end
			end
		end

		field :sign_in, :user do
			arg :username, non_null(:string)
			arg :password, non_null(:string)
			
			resolve fn params, _ ->
				with {:ok, user} <- Auth.verify_and_sign(params) do
					{:ok, user}
				else
					{:error, error} ->
						{:error, ["errors", "more errors"]} 
				end
			end
		end
	end

	object :user do
		field :id, :id
		field :jwt, :string
		field :username, :string
		field :password, :string
		field :password_confirmation, :string
	end
end
