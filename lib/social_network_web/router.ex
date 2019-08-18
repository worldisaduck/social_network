defmodule SocialNetworkWeb.Router do
  use SocialNetworkWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
		plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
		plug :fetch_session
  end

	pipeline :jwt_auth do
		plug SocialNetworkWeb.Plugs.Auth.AuthenticateToken 
	end

	forward "/graphiql", Absinthe.Plug.GraphiQL, schema: SocialNetwork.Schema

  scope "/", SocialNetworkWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

	scope "/api", SocialNetworkWeb do
		pipe_through [:api, :jwt_auth]

		scope "/v1" do
			resources "/users", UserController
			post "/sign-up", Api.V1.RegistrationController, :create
			post "/sign-in", Api.V1.SessionController, :create
		end
	end
  # Other scopes may use custom stacks.
  # scope "/api", SocialNetworkWeb do
  #   pipe_through :api
  # end
end
