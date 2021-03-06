# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :hack_pop, HackPop.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "hack_pop_repo",
  username: "postgres",
  password: "",
  hostname: "localhost",
  port: 5432

config :hack_pop, ecto_repos: [HackPop.Repo]

config :hack_pop, apns_pool: :dev_pool

config :hack_pop, apns_client: HackPop.APNS.Client

config :hack_pop, error_reporting: HackPop.Errors.Reporting

config :hack_pop, hacker_news_client: HackPop.HackerNews.HTTPClient

config :logger, level: :info

config :plug, port: 4001

config :apns,
  callback_module: HackPop.APNS.Callback,
  pools: [
    dev_pool: [
      env: :dev,
      certfile: "secrets/apns_dev.pem",
      pool_size: 10
    ],
    prod_pool: [
      env: :prod,
      certfile: "secrets/apns_prod.pem",
      pool_size: 100
    ]
  ]

config :bugsnag, api_key: System.get_env("BUGSNAG_API_KEY")

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :hack_pop, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:hack_pop, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#

import_config "#{Mix.env}.exs"
