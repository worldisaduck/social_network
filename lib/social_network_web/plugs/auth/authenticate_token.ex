defmodule SocialNetworkWeb.Plugs.Auth.AuthenticateToken do
	import Plug.Conn
	alias SocialNetwork.Auth
	require IEx

	def init(opts), do: opts


	def call(conn, _opts) do
		with {:ok, token} <- fetch_token_from_header(conn),
				 {:ok, token} <- Auth.verify_token(token) do
			conn
		else
			:no_token_found ->
				send_resp(conn, 401, "no token found")	
			{:error, :invalid_token} ->
				send_resp(conn, 401, "invalid token")	
		end
	end

	defp fetch_token_from_header(conn) do
		case get_req_header(conn, "authorization") do
   		["Bearer " <> token] -> {:ok, token}
    	[anything] -> :wrong_authorization_type
    	_	-> :no_token_found
  	end
	end
end
