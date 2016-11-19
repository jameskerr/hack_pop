require Logger

defmodule HackPop.Pinger do
  alias HackPop.Parser
  alias HackPop.Story
  alias HackPop.Pusher

  @url "https://hacker-news.firebaseio.com/v0/topstories.json"
  @interval 60_000 * 5

  def start_link do
    Task.start_link __MODULE__, :forever_ping, []
  end

  def forever_ping do
    Task.start __MODULE__, :ping, []
    :timer.sleep(@interval)
    forever_ping
  end

  def ping do
    @url
    |> HTTPoison.get
    |> handle_response
  end

  def error(error, token) do
    Bugsnag.report(error, severity: "error", user: %{id: token})
  end

  def feedback(feedback) do
    Bugsnag.report(feedback, severity: "info")
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Parser.find_stories
    |> Story.save_all
    |> Story.set_trending
    |> Pusher.push_to_all_clients
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    Logger.error "error: (#{status_code})"
  end
end
