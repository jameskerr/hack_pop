defmodule HackPop.HackerNews.Api do
  alias HTTPoison.Response

  @top_stories_url "https://hacker-news.firebaseio.com/v0/topstories.json"

  def get_story(id) do
    {:ok, %Response{status_code: 200, body: body}} = HTTPoison.get story_url(id)

    body
    |> Poison.decode!
    |> build_story
  end

  def get_top_stories do
    {:ok, %Response{status_code: 200, body: body}} = HTTPoison.get @top_stories_url

    body
    |> Poison.decode!
    |> Enum.take(30)
    |> Enum.map(&(Task.async(fn -> __MODULE__.get_story(&1) end)))
    |> Enum.map(&Task.await(&1))
  end

  defp build_story(story) do
    %HackPop.Schemas.Story{
      id:           story["id"],
      title:        story["title"],
      url:          parse_story_url(story),
      points:       story["score"],
      comments_url: "item?id=#{story["id"]}"
    }
  end

  defp story_url(id), do: "https://hacker-news.firebaseio.com/v0/item/#{id}.json"

  defp parse_story_url(%{"url" => url}), do: url

  defp parse_story_url(%{"id" => id}), do: "https://news.ycombinator.com/item?id=#{id}"
end
