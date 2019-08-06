defmodule SocialNetworkWeb.Plugs.Auth.VerifyHeader do
	import Plug.Conn

	def init(opts), do: opts

	def call(conn, _opts) do
#		with {:ok, token} <- fetch_token_from_header(conn)		
	end

	defp fetch_token_from_header(conn) do
	
	end
end
