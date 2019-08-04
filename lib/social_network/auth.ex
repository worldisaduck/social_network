defmodule SocialNetwork.Auth do
	def encode_and_sign(user, params \\ %{}) do
		secret = Application.get_env(:social_network, SocialNetworkWeb.Endpoint)[:secret_key_base]
		encoded_header = header |> Jason.encode! |> Base.url_encode64
		encoded_payload = user |> payload |> Jason.encode! |> Base.url_encode64
		encoded_signature = :crypto.hmac(:sha256, secret, "#{encoded_header}.#{encoded_payload}") |> Base.url_encode64

		token = [encoded_header, encoded_payload, encoded_signature] |> Enum.join(".")
		{:ok, token}
	end

	defp header do
		%{
			"alg" => "HS256",
			"typ" => "JWT"
		}
	end

	defp payload(user) do
		%{
			"iss" => Application.get_env(:social_network, SocialNetworkWeb.Endpoint)[:issuer],
			"sub" => user.id,
			"exp" => DateTime.to_unix(DateTime.utc_now) + 365 * 24 * 60 * 60
		}
	end
end
