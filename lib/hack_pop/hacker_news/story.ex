defmodule HackPop.HackerNews.Story do
  @client Application.get_env(:hack_pop, :hacker_news_client)

  def get(id) do
    @client.story(id)
    |> handle_response
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Poison.decode!
    |> build_story
  end

  defp build_story(story = %{}) do
    %HackPop.Schema.Story{
      id:           story["id"],
      title:        story["title"],
      url:          parse_url(story),
      points:       story["score"],
      comments_url: "item?id=#{story["id"]}"
    }
  end

  defp parse_url(%{"url" => url}), do: url

  defp parse_url(%{"id" => id}), do: "https://news.ycombinator.com/item?id=#{id}"
end
