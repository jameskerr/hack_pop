defmodule HackPop.Views.ClientView do
  @derive [Poison.Encoder]
  defstruct [:id, :threshold]

  def cast(story) do
    struct __MODULE__, Map.take(story, fields)
  end

  defp fields do
    %__MODULE__{}
    |> Map.keys
    |> List.delete(:__struct__)
  end
end
