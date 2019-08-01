defmodule SocialNetworkWeb.Api.V1.RegistrationController do
	use SocialNetworkWeb, :controller 
	require IEx
	alias SocialNetwork.Accounts
	alias SocialNetwork.Accounts.User

  action_fallback SocialNetworkWeb.FallbackController

	def create(conn, %{"user" => user_params}) do
		render(conn, "success.json")
	end
end
