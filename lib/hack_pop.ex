require Logger

defmodule HackPop do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Bugsnag.start(nil, nil)

    children = [
      worker(HackPop.Repo, []),
      Plug.Adapters.Cowboy.child_spec(:http, HackPop.Web, [], [port: Application.fetch_env!(:plug, :port)])
    ]

    if auto_ping? do
      children = children ++ [worker(HackPop.Pinger, [])]
    end

    opts = [strategy: :one_for_one, name: HackPop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp auto_ping? do
    Application.fetch_env!(:hack_pop, :auto_ping)
  end
end


