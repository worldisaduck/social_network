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


  scope "/" do
    pipe_through :jwt_auth

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: SocialNetwork.Schema
  end

# Other scopes may use custom stacks.
# scope "/api", SocialNetworkWeb do
#   pipe_through :api
# end
end
