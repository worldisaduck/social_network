defmodule SocialNetworkWeb.Plugs.Auth.AuthenticateToken do
  @behaviour Plug

	import Plug.Conn
	alias SocialNetwork.Auth
  alias SocialNetwork.Accounts.User

	def init(opts), do: opts

	def call(%Plug.Conn{path_info: ["api", "v1", "sign-up"]} = conn, _opts), do: conn

	def call(%Plug.Conn{path_info: ["api", "v1", "sign-in"]} = conn, _opts), do: conn

	def call(conn, _opts) do
		with {:ok, token} <- fetch_token_from_header(conn),
				 {:ok, token} <- Auth.verify_token(token),
         %User{} = current_user <- Auth.authorize(token) do
			Absinthe.Plug.put_options(conn, %{context: %{current_user: current_user}})
		else
			:no_token_found ->
        Absinthe.Plug.put_options(conn, %{context: %{current_user: %{}}})
			{:error, :invalid_token} ->
        Absinthe.Plug.put_options(conn, %{context: %{current_user: %{}}})
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
