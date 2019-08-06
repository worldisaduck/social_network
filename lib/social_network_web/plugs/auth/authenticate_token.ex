defmodule SocialNetworkWeb.Plugs.Auth.AuthenticateToken do
	import Plug.Conn
	require IEx
	def init(opts), do: opts

	def call(conn, _opts) do
		with {:ok, token} <- fetch_token_from_header(conn),
				 {:ok, token} <- verify_claims(token) do
		else
			:no_token_found ->
				send_resp(conn, 401, "no token found")	
			{:error, :invalid_token} ->
				IEx.pry
		end
	end

	defp fetch_token_from_header(conn) do
		case get_req_header(conn, "authorization") do
   		["Bearer " <> token] -> token
    	[anything] -> :wrong_authorization_type
    	_	-> :no_token_found
  	end
	end

	defp verify_claims(token) do

	end
end
