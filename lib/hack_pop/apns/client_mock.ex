require Logger

defmodule HackPop.APNS.ClientMock do
  def start do
    Logger.debug "APNS.ClientMock.start"
  end

  def push(message, opts \\ []) do
    Logger.debug "APNS.ClientMock.push #{inspect(message)}, #{inspect(opts)}"
  end
end
