require Logger

defmodule HackPop.APNS.Callback do
  @errors Application.get_env(:hack_pop, :error_reporting)

  defmodule APNSError do
    defexception [:message]
  end

  def error(error, token) do
    try do
      raise __MODULE__.APNSError, error.error
    rescue
      e -> @errors.report(e, metadata: %{details: error, token: %{token: token}})
    end
  end

  def feedback(feedback) do
    Logger.info inspect(feedback)
  end
end
