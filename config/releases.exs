import Config

# Format: ecto://USER:PASS@HOST/DATABASE
database_url = System.fetch_env!("DATABASE_URL")
pool_size = System.get_env("POOL_SIZE") || "10"

config :valoris, Valoris.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(pool_size)

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
application_port = System.get_env("PORT") || "4000"

config :valoris, ValorisWeb.Endpoint,
  http: [
    port: String.to_integer(application_port),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :valoris, ValorisWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

# # For future reference
# req_runtime_config = System.fetch_env!("REQUIRED_CONFIG_VALUE")
# opt_runtime_config = System.get_env("OPTIONAL_CONFIG_VALUE") || "default"
#
# config :valoris,
#   optional_value: opt_runtime_config,
#   required_value: req_runtime_config
