require Logger

defmodule HackPop do
  use Application

  @url "https://news.ycombinator.com/"

  def start(_type, _args) do
    HackPop.Supervisor.start_link
  end

  def request do
    try do
      HTTPoison.get(@url) |> handle_response
    rescue
      error in HTTPoison.HTTPError ->
        Logger.info "Http error (#{inspect error.message})"
    end
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    HackPop.Parser.find_stories(body)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    Logger.info "error: (#{status_code})"
  end
end


