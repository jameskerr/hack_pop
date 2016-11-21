require Logger

defmodule HackPop.Errors.TestReporting do
  def start do
    Logger.debug "[TEST] Error reporting started"
  end

  def report(exception, options) do
    Logger.debug "[TEST] Error reported: #{inspect(exception)}, #{inspect(options)}"
  end
end
