defmodule SocialNetworkWeb.Api.V1.RegistrationView do
	use SocialNetworkWeb, :view
	require IEx
	alias SocialNetworkWeb.RegistrationView

	def render("success.json", _) do
		%{
			success: true
		}	
	end

	def render("error.json", %{"errors" => errors}) do
		%{
			errors: errors
		}
	end
end
