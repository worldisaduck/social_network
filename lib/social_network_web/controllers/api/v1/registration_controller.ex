defmodule SocialNetworkWeb.Api.V1.RegistrationController do
	use SocialNetworkWeb, :controller 
	require IEx
	alias SocialNetwork.Accounts
	alias SocialNetwork.Accounts.User

  action_fallback SocialNetworkWeb.FallbackController

	def create(conn, %{"user" => user_params}) do
		with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
			render(conn, "success.json")
		else
			{:error, changeset} ->	
				errors = Enum.map(changeset.errors, fn(error) ->
					value = elem(error, 1) |> elem(0)
					%{elem(error, 0) => value}
				end)
			render(conn, "error.json", %{"errors" => errors})
		end
	end
end
