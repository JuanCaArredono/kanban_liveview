# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kanban_liveview,
  ecto_repos: [KanbanLiveview.Repo]

# Configures the endpoint
config :kanban_liveview, KanbanLiveviewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZG3SVk+KvfZA2Hg0aLIwHSset2mOSccm8GEDocaFgXDYo4Rm8vbL1znuHpLzN5RR",
  render_errors: [view: KanbanLiveviewWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: KanbanLiveview.PubSub,
  live_view: [signing_salt: "ZNiJfLwm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
