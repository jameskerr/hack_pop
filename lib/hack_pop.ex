require Logger

defmodule HackPop do
  use Application

  def start(_type, _args) do
    HackPop.Supervisor.start_link
  end
end


