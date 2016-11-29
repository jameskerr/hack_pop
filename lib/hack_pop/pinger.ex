defmodule HackPop.Pinger do
  @interval 60_000 * 5

  alias HackPop.Services.{StoryService, PushService}

  def start_link do
    Task.start_link __MODULE__, :forever_ping, []
  end

  def forever_ping do
    Task.start __MODULE__, :ping, []
    :timer.sleep @interval
    forever_ping
  end

  def ping do
    HackPop.HackerNews.Api.get_top_stories
    |> StoryService.save_all
    |> StoryService.set_trending
    |> PushService.push_to_all_clients
  end
end
