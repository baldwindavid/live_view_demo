# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :live_app,
  ecto_repos: [LiveApp.Repo]

# Configures the endpoint
config :live_app, LiveAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YAAvvMX0W44Y2B4m//Yc3xUJjaPFA/RunjG82/nzumzwnfkLIs9FPLPLXon5mnsh",
  render_errors: [view: LiveAppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveApp.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "qznqFiVo8H+moovo8n6rM9vmj2p+L8Xe"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
