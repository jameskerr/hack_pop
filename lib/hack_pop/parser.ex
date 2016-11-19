defmodule HackPop.Parser do
  def find_stories(body) do
    body
    |> Poison.decode!
    |> Enum.take(30)
    |> Enum.map(&(Task.async(fn -> fetch_story(&1) end)))
    |> Enum.map(&Task.await(&1))
  end

  def fetch_story(id) do
    id
    |> build_story_url
    |> HTTPoison.get
    |> handle_story_response
  end

  defp handle_story_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    story = Poison.decode!(body)

    %HackPop.Story{
      title:        story["title"],
      url:          parse_url(story),
      points:       story["score"],
      comments_url: "item?id=#{story["id"]}"
    }
  end

  defp build_story_url(id), do: "https://hacker-news.firebaseio.com/v0/item/#{id}.json"

  defp parse_url(%{"url" => url}), do: url

  defp parse_url(%{"id" => id}), do: "https://news.ycombinator.com/item?id=#{id}"
end
