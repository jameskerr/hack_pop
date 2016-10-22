defmodule HackPop.Parser do
  def find_stories(body) do
    list = List.zip([
      find_titles(body),
      find_urls(body),
      find_points(body),
      find_comment_urls(body)
    ])

    Enum.map(list, &build_story/1)
  end

  # PRIVATE

  defp build_story({title, url, points, comments_url}) do
    %HackPop.Story{title: title, url: url, points: points, comments_url: comments_url}
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

  defp find_points(body) do
    body
     |> Floki.find("tr .score")
     |> Enum.map(fn(html) ->
      string = Floki.FlatText.get(html)
      [points|_] = String.split(string, " ")
      {int, _} = Integer.parse(points)
      int
    end)
  end

  defp find_comment_urls(body) do
    body
    |> Floki.attribute(".subtext a", "href")
    |> Enum.filter(fn link -> String.match?(link, ~r/^item\?id=\d+$/) end)
    |> Enum.uniq
  end
end
