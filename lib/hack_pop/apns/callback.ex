require Logger

defmodule HackPop.APNS.Callback do
  defmodule APNSError do
    defexception [:message]
  end

  def error(error, token) do
    try do
      raise __MODULE__.APNSError, error.error
    rescue
      e -> Bugsnag.report(e, metadata: %{details: error, token: %{token: token}})
    end
  end

  def feedback(feedback) do
    Logger.info inspect(feedback)
  end
end
