defmodule SocialNetworkWeb.RegistrationView do
	use SocialNetworkWeb, :view
	alias SocialNetworkWeb.RegistrationView

	def render("success.json", _) do
		%{
			success: true
		}	
	end
end
