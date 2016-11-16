defmodule HackPop.Mixfile do
  use Mix.Project

  def project do
    [app: :hack_pop,
     version: "0.0.8",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: HackPop],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger,
                    :httpoison,
                    :floki,
                    :ecto,
                    :postgrex,
                    :timex,
                    :cowboy,
                    :poison,
                    :apns,
                    :bugsnag,
                    :plugsnag,
                    :plug,
                    :edeliver],
     mod: {HackPop, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.8.0"},
     {:floki, "~> 0.9.0"},
     {:ecto, "~> 2.0"},
     {:postgrex, "~> 0.11"},
     {:timex, "~> 3.0"},
     {:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:poison, "~> 2.0"},
     {:apns, "~> 0.9.1"},
     {:bugsnag, "~> 1.3.2"},
     {:plugsnag, "~> 1.1.0"},
     {:edeliver, "~> 1.4.0"},
     {:distillery, ">= 0.8.0", warn_missing: false},
     {:exvcr, "~> 0.7", only: :test}]
  end
end
