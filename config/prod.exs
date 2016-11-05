use Mix.Config

config :hack_pop, HackPop.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("DB_NAME"),
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST")

config :apns,
  pools: [
    dev_pool: [
      env: :dev,
      certfile: "secrets/apns_dev.pem"
    ]
  ]

config :bugsnag, api_key: System.get_env("BUGSNAG_API_KEY")
config :bugsnag, release_stage: "prod"
