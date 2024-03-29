# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# config :dallas,
#   ecto_repos: [Dallas.Repo]

# Configures the endpoint
config :dallas, DallasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XS56afTGi8Hpx9JVYNuPn7ULcK+hnCpMnm+O4ZPpoEYP1DB1wZfAS79EJlryTFRi",
  render_errors: [view: DallasWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Dallas.PubSub,
  live_view: [signing_salt: "7n4VJEQO"]

config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
  ]

config :dart_sass,
  version: "1.43.4",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


secret_path =
  __ENV__.file
  |> Path.dirname()
  |> Path.join("#{Mix.env()}.secret.exs")

if File.exists?(secret_path) do
  import_config "#{Mix.env()}.secret.exs"
end
