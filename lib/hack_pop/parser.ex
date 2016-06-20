defmodule HackPop.Parser do

  def find_stories(body) do
    Enum.filter(all_stories(body), fn({_title, score}) -> score > 300 end)
  end

  defp all_stories(body) do
    Enum.zip(titles(body), scores(body))
  end

  defp titles(body) do
    body
      |> Floki.find(".storylink")
      |> Enum.map(fn(html) -> Floki.FlatText.get(html) end)
  end

  defp scores(body) do
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
