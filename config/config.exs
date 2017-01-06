# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :movie_catalog,
  ecto_repos: [MovieCatalog.Repo]

# Configures the endpoint
config :movie_catalog, MovieCatalog.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LnFyExB1ulu5H9tZQ1PaeqAmMdB7P17b4Jq+tGWYpExFxpxwjssLAtqEl8sEJbMh",
  render_errors: [view: MovieCatalog.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MovieCatalog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
