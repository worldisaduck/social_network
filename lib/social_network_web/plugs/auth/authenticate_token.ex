defmodule SocialNetworkWeb.Plugs.Auth.AuthenticateToken do
	import Plug.Conn
	alias SocialNetwork.Auth
	require IEx

	def init(opts), do: opts

	def call(%Plug.Conn{path_info: ["api", "v1", "sign-up"]} = conn, _opts), do: conn

	def call(conn, _opts) do
		with {:ok, token} <- fetch_token_from_header(conn),
				 {:ok, token} <- verify_token(token) do
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

	defp verify_token(token) do
		splited_token = String.split(token, ".")
		[encoded_header, encoded_payload, encoded_signature] = splited_token
		with :ok <- decode_and_verify_signature(splited_token),
				 :ok <- decode_and_verify_claims(encoded_payload) do
			{:ok, token}
		else
			{:error, :invalid_token} ->
				{:error, :invalid_token}
		end
	end

	defp decode_and_verify_signature(splited_token) do
		[encoded_header, encoded_payload, encoded_signature] = splited_token
		case Base.url_decode64!(encoded_signature, padding: true) == Auth.signature(encoded_header, encoded_payload) do
			true 	-> :ok
			false -> {:error, :invalid_token}
		end
	end

	defp decode_and_verify_claims(claims) do
		case claims |> Base.url_decode64!(padding: false) |> Jason.decode! |> Map.get("exp") do
			nil -> :ok
			exp_at_in_sec ->
				if exp_at_in_sec > DateTime.to_unix(DateTime.utc_now) do
					:ok
				else
					{:error, :invalid_token}
				end
		end
	end
end
