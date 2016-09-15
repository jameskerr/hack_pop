require Logger

defmodule HackPop do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(HackPop.Stories, []),
      worker(HackPop.Pinger, [])
    ]

    opts = [strategy: :one_for_one, name: HackPop.Supervisor]
    Supervisor.start_link(children, opts)
  end
end


