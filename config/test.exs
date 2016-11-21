use Mix.Config

config :hack_pop, HackPop.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "hack_pop_repo_test",
  username: "postgres",
  password: "",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :hack_pop, ecto_repos: [HackPop.Repo]

config :hack_pop, Repo, pool: Ecto.Adapters.SQL.Sandbox

config :hack_pop, error_reporting: HackPop.Errors.TestReporting

config :logger, level: :warn

config :plug, port: 4002

config :apns, pools: []

