require Logger

defmodule HackPop do
  use Application

  def start(_type, _args) do
    Supervisor.start_link children, strategy: :one_for_one, name: HackPop.Supervisor
  end

  defp children do
    case Mix.env do
      :test -> [repo, web]
      _     -> [repo, web, pinger, error_reporting]
    end
  end

  defp pinger do
    Supervisor.Spec.worker HackPop.Pinger, []
  end

  defp repo do
    Supervisor.Spec.worker HackPop.Repo, []
  end

  defp web do
    Plug.Adapters.Cowboy.child_spec(
      :http,
      HackPop.Web,
      [],
      port: Application.fetch_env!(:plug, :port)
    )
  end

  defp error_reporting do
    Supervisor.Spec.worker HackPop.ErrorReporting, []
  end
end
