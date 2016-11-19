use Mix.Config

config :hack_pop, HackPop.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("DB_NAME"),
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOST")

config :hack_pop, apns_pool: :prod_pool

config :bugsnag, release_stage: System.get_env("BUGSNAG_RELEASE_STAGE")
