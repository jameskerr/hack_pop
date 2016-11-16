require Logger

defmodule HackPop do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Bugsnag.start(nil, nil)

    children = [
      worker(HackPop.Repo, []),
      worker(HackPop.Pinger, []),
      Plug.Adapters.Cowboy.child_spec(:http, HackPop.Web, [], [port: Application.fetch_env!(:plug, :port)])
    ]

    opts = [strategy: :one_for_one, name: HackPop.Supervisor]
    Supervisor.start_link(children, opts)
  end
end


