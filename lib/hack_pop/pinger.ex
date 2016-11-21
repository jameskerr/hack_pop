defmodule HackPop.Pinger do
  @interval 60_000 * 5

  def start_link do
    Task.start_link __MODULE__, :forever_ping, []
  end

  def forever_ping do
    Task.start __MODULE__, :ping, []
    :timer.sleep @interval
    forever_ping
  end

  def ping do
    HackPop.HackerNews.TopStories.get
    |> HackPop.Schema.Story.save_all
    |> HackPop.Schema.Story.set_trending
    |> HackPop.Pusher.push_to_all_clients
  end
end
