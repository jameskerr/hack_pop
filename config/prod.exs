use Mix.Config

config :hack_pop, HackPop.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "${DB_NAME}",
  username: "${DB_USER}",
  password: "${DB_PASSWORD}",
  hostname: "${DB_HOST}"

config :apns,
  pools: [
    dev_pool: [
      env: :dev,
      certfile: "secrets/apns_dev.pem"
    ]
  ]

config :bugsnag, api_key: "${BUGSNAG_API_KEY}"
config :bugsnag, release_stage: "prod"
