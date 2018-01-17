use Mix.Config


config :so_so_soccer, SoSoSoccerWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

config :so_so_soccer, SoSoSoccerWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/so_so_soccer_web/views/.*(ex)$},
      ~r{lib/so_so_soccer_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :eventstore, EventStore.Storage,
  serializer: EventStore.JsonbSerializer,
  types: EventStore.PostgresTypes,
  username: "so_so_soccer",
  password: "so_so_soccer",
  database: "so_so_soccer_eventstore_dev",
  hostname: "localhost",
  port: 5432,
  pool: DBConnection.Poolboy,
  pool_size: 10

config :so_so_soccer, SoSoSoccer.EventSourced.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "so_so_soccer",
  password: "so_so_soccer",
  database: "so_so_soccer_readstore_dev",
  hostname: "localhost",
  port: 5432,
  pool_size: 10

config :so_so_soccer, SoSoSoccer.Crud.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "so_so_soccer",
  password: "so_so_soccer",
  database: "so_so_soccer_crud_dev",
  hostname: "localhost",
  pool_size: 10
