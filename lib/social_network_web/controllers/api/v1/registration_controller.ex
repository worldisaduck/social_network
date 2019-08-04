defmodule SocialNetworkWeb.Api.V1.RegistrationController do
	use SocialNetworkWeb, :controller 
	require IEx
	alias SocialNetwork.Accounts
	alias SocialNetwork.Accounts.User

  action_fallback SocialNetworkWeb.FallbackController

	def create(conn, %{"user" => user_params}) do
		with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
			conn
			|> put_session(:current_user_id, user.id)
			|> render("success.json")
		end
	end
end
