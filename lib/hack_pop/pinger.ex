require Logger

defmodule HackPop.Pinger do
  alias HackPop.Parser
  alias HackPop.Story
  alias HackPop.Pusher


  @url "https://hacker-news.firebaseio.com/v0/topstories.json"
  @interval 60_000 * 5

  @name __MODULE__

  def start_link do
    Task.start_link __MODULE__, :forever_ping, []
  end

  def forever_ping do
    Task.start @name, :ping, []
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
    Parser.find_stories(body)
    |> Story.save_all
    |> Story.set_trending
    |> Pusher.push_to_all_clients
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    Logger.info "error: (#{status_code})"
  end
end
