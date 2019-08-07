defmodule SocialNetworkWeb.Api.V1.SessionController do
	use SocialNetworkWeb, :controller
	alias SocialNetwork.Auth
	require IEx
	action_fallback SocialNetworkWeb.FallbackController

	def create(conn, %{"session" => session_params}) do
		with {:ok, token} <- Auth.verify_and_sign(session_params) do
			conn
				|> json(%{jwt: token})
		end
	end
end
