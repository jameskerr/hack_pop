defmodule HackPop.Services.StoryService do

  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Schemas.Story

  def save_all(stories) do
    stories
    |> Enum.map(&upsert/1)
  end

  def set_trending(stories) do
    stories_trending_besides(stories)
    |> Repo.update_all(set: [trending: false])
    stories
  end

  defp upsert(struct) do
    case story = Repo.get(Story, struct.id) do
      nil ->
        struct
        |> Repo.insert!
      %Story{} ->
        story
        |> Story.changeset(%{points: struct.points, trending: true})
        |> Repo.update!
    end
  end

  defp ids(stories) do
    Enum.map stories, fn story -> story.id end
  end

  defp stories_trending_besides(stories) do
    from s in Story,
      where:  s.trending == true
      and not s.id in ^ids(stories)
  end
end
