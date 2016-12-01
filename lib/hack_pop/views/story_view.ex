defmodule HackPop.Views.StoryView do
  @derive [Poison.Encoder]
  defstruct [:id, :title, :url, :comments_url, :points]

  def cast([]), do: []

  def cast(story = %{}) do
    struct __MODULE__, Map.take(story, fields)
  end

  def cast(list) do
    Enum.map list, &cast/1
  end

  defp fields do
    %__MODULE__{}
    |> Map.keys
    |> List.delete(:__struct__)
  end
end
