use Mix.Config

config :hack_pop, HackPop.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("DB_NAME"),
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST")

config :plug, port: 80

config :apns,
  pools: [
    dev_pool: [
      env: :dev,
      certfile: "secrets/apns_dev.pem"
    ]
  ]
