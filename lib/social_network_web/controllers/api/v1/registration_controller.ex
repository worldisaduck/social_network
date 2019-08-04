defmodule SocialNetworkWeb.Api.V1.RegistrationController do
	use SocialNetworkWeb, :controller 
	require IEx
	alias SocialNetwork.{Accounts, Auth}
	alias SocialNetwork.Accounts.User

  action_fallback SocialNetworkWeb.FallbackController

	def create(conn, %{"user" => user_params}) do
		with {:ok, %User{} = user} <- Accounts.create_user(user_params),
				 {:ok, token} <- Auth.encode_and_sign(user) do
			conn
			|> render("success.json", %{"jwt" => token})
		end
	end
end
