defmodule MovieCatalog.Router do
  use MovieCatalog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MovieCatalog.Auth, repo: MovieCatalog.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MovieCatalog do
    pipe_through :browser # Use the default browser stack

    get "/", MovieController, :index

    resources "/movies", MovieController, only: [:show]
    resources "/registrations", RegistrationController, only: [:new, :create]

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete
  end

  scope "/manage", MovieCatalog do
    pipe_through [:browser, :authenticate_user]

    resources "/movies", MovieController, only: [:new, :create]
    resources "/comments", CommentController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MovieCatalog do
  #   pipe_through :api
  # end
end
