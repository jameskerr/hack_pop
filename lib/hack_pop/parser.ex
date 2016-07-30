defmodule HackPop.Parser do

  @min_score 300

  def find_stories(body) do
    Enum.filter(all_stories(body), fn(story) -> story.score > @min_score end)
  end

  defp all_stories(body) do
    List.zip([find_titles(body), find_urls(body), find_scores(body)])
      |> Enum.map(&build_story/1)
  end

  defp build_story({title, url, score}) do
    %{title: title, url: url, score: score}
  end

  defp find_titles(body) do
    body
      |> Floki.find(".storylink")
      |> Enum.map(fn(html) -> Floki.FlatText.get(html) end)
  end

  defp find_urls(body) do
    body
      |> Floki.find(".storylink")
      |> Floki.attribute("href")
  end

  defp find_scores(body) do
    body
     |> Floki.find("tr .score")
     |> Enum.map(fn(html) ->
      string = Floki.FlatText.get(html)
      [points|_] = String.split(string, " ")
      {int, _} = Integer.parse(points)
      int
    end)
  end
end
