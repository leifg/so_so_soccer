# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :so_so_soccer,
  ecto_repos: [SoSoSoccer.Crud.Repo]

# Configures the endpoint
config :so_so_soccer, SoSoSoccerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dMnVLJ27Y4fUXCY2QlMmsqEAhy0Kyu4Gt03n8mrNU3tjXUa8YzWdvwE2ZQb/9cf1",
  render_errors: [view: SoSoSoccerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SoSoSoccer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
