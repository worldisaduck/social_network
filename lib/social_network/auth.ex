defmodule SocialNetwork.Auth do
  alias SocialNetwork.Accounts

  def encode_and_sign(user, params \\ %{}) do
    encoded_header = header |> Jason.encode! |> Base.url_encode64(padding: true)
    encoded_payload = user |> payload |> Jason.encode! |> Base.url_encode64(padding: true)
    encoded_signature = signature(encoded_header, encoded_payload) |> Base.url_encode64(padding: true)

    token = [encoded_header, encoded_payload, encoded_signature] |> Enum.join(".")
    {:ok, %{user | jwt: token}}
  end

  def verify_and_sign(%{username: username, password: pass}) do
    with %SocialNetwork.Accounts.User{} = user <- Accounts.find_by_username(username),
         {:ok, _} <- Comeonin.Bcrypt.check_pass(user, pass) do
           encode_and_sign(user)
    else
      nil ->
        Comeonin.Bcrypt.dummy_checkpw
        {:error, :unauthorized}
        {:error, "invalid password"} -> {:error, :unauthorized}
      false -> {:error, :unauthorized}
    end
  end

  def authorize(token) do
    with {:ok, token} <- verify_token(token) do
      decode_payload(token)
      |> Map.get("sub")
      |> Accounts.get_user!
    else
      {:error, :invalid_token} -> {:error, :invalid_token}
    end
  end

    def verify_token(token) do
      splited_token = split_token(token)
      [encoded_header, encoded_payload, encoded_signature] = splited_token
      with :ok <- decode_and_verify_signature(splited_token),
           :ok <- decode_and_verify_claims(encoded_payload) do
        {:ok, token}
      else
        {:error, :invalid_token} -> {:error, :invalid_token}
      end
    end

  def signature(encoded_header, encoded_payload) do
    secret = Application.get_env(:social_network, SocialNetworkWeb.Endpoint)[:secret_key_base]
    :crypto.hmac(:sha256, secret, "#{encoded_header}.#{encoded_payload}")		
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

  defp decode_payload(token) do
    [_, encoded_payload, _] = split_token(token)
    encoded_payload
    |> Base.url_decode64!
    |> Jason.decode!
  end

  defp split_token(token), do: String.split(token, ".")

  defp decode_and_verify_signature(splited_token) do
    [encoded_header, encoded_payload, encoded_signature] = splited_token
    case Base.url_decode64!(encoded_signature, padding: true) == signature(encoded_header, encoded_payload) do
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

