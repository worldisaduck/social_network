defmodule SocialNetwork.Schema do
	use Absinthe.Schema
	alias SocialNetwork.Accounts
	alias SocialNetwork.Auth
  alias SocialNetwork.Accounts.User

	query do
		field :all_users, list_of(:user) do
			resolve &Accounts.list_users/2
		end

    field :get_friends, list_of(:friend) do
      resolve fn _, %{context: %{current_user: current_user}} ->
        case current_user do
          %User{} -> {:ok, Accounts.friends_and_subs(current_user.id)}
          %{} -> {:error, ["errors", "more errors"]}
        end
      end
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


		field :update_profile, :profile do
			arg :user_id, non_null(:integer)
			arg :first_name, :string
			arg :surname, :string
			arg :patronymic, :string
			arg :date_of_birth, :string
			arg :gender, :string
			arg :city_of_origin, :string
			arg :city_of_living, :string
			arg :info, :string

			resolve fn params, _ ->
				with {:ok, user} <- Accounts.update_user_profile(params) do
					{:ok, user}
				else
					{:error, error} ->
						{:error, "error"}
				end
			end
		end
	end

  object :friend do
    field :state, :string
    field :user, :user
  end

	object :user do
		field :id, :id
		field :jwt, :string
		field :username, :string
		field :password, :string
		field :password_confirmation, :string
		field :profile, :profile
	end

	object :profile do
		field :first_name, :string
		field :surname, :string
		field :patronymic, :string
		field :date_of_birth, :string
		field :gender, :string
		field :city_of_living, :string
		field :city_of_origin, :string
		field :info, :string
	end
end
