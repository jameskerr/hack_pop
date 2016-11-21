require Logger

defmodule HackPop.Errors.ReportingMock do
  def start do
    Logger.debug "Errors.ReportingMock.start"
  end

  def report(exception, options) do
    Logger.debug "Errors.ReportingMock.report #{inspect(exception)}, #{inspect(options)}"
  end
end
