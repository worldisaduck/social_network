defmodule SocialNetworkWeb.RegistrationController do
	use SocialNetworkWeb, :controller 
	require IEx
	alias SocialNetwork.Accounts
	alias SocialNetwork.Accounts.User

  action_fallback SocialNetworkWeb.FallbackController

	def create(conn, %{"user" => user}) do
		render(conn, "success.json")
	end
end
