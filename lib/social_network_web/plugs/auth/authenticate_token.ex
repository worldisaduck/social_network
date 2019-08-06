defmodule SocialNetworkWeb.Plugs.Auth.AuthenticateToken do
	import Plug.Conn
	alias SocialNetwork.Auth
	require IEx

	def init(opts), do: opts

	def call(conn, _opts) do
		with {:ok, token} <- fetch_token_from_header(conn),
				 {:ok, token} <- verify_signature(token) do
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

	defp verify_signature(token) do
		[encoded_header, encoded_payload, encoded_signature] = fetch_token_parts(token)	
		IEx.pry
		case Base.url_decode64!(encoded_signature) == Auth.signature(encoded_header, encoded_payload) do
			true 	-> {:ok, token} 
			false -> {:error, :invalid_token}
		end
	end

	defp fetch_token_parts(token) do
		token |> String.split(".")
	end
end
