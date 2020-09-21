# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :valoris,
  ecto_repos: [Valoris.Repo]

# Configures the endpoint
config :valoris, ValorisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9p2v5rPdQqRHXuAFvNXXH9ZFqoxdj//4h0g0tTy/Y8vxJXGzRw2tWPni5fXbVazC",
  render_errors: [view: ValorisWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Valoris.PubSub,
  live_view: [signing_salt: "FKg1DGNZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
