require Logger

defmodule HackPop.Pinger do
  @url "https://news.ycombinator.com"
  @interval 15_000

  def start_link do
    pid = spawn __MODULE__, :forever_ping, []
    {:ok, pid}
  end

  def forever_ping do
    ping
    :timer.sleep(@interval)
    forever_ping
  end

  def ping do
    try do
      HTTPoison.get(@url) |> handle_response
    rescue
      error in HTTPoison.HTTPError ->
        Logger.info "Http error (#{inspect error.message})"
    end
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    HackPop.Parser.find_stories(body)
    |> Enum.each(&HackPop.Stories.update/1)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    Logger.info "error: (#{status_code})"
  end
end