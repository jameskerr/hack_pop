require Logger

defmodule HackPop.HackerNews.TopStories do
  @client Application.get_env(:hack_pop, :hacker_news_client)

  def get do
    @client.top_stories
    |> handle_response
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Poison.decode!
    |> Enum.take(30)
    |> Enum.map(&(Task.async(fn -> HackPop.HackerNews.Story.get(&1) end)))
    |> Enum.map(&Task.await(&1))
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    Logger.error "error: (#{status_code})"
  end
end
