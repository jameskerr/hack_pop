defmodule HackPop do
  use Application
  import Supervisor.Spec, only: [worker: 2]

  def start(_type, _args) do
    Application.get_env(:hack_pop, :error_reporting).start
    Supervisor.start_link children, strategy: :one_for_one, name: HackPop.Supervisor
  end

  defp children do
    case Mix.env do
      :test -> [repo, web]
      _     -> [repo, web, pinger]
    end
  end

  defp pinger do
    worker HackPop.Pinger, []
  end

  defp repo do
    worker HackPop.Repo, []
  end

  defp web do
    Plug.Adapters.Cowboy.child_spec(
      :http,
      HackPop.Web,
      [],
      port: Application.fetch_env!(:plug, :port)
    )
  end
end
