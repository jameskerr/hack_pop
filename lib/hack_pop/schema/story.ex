defmodule HackPop.Schema.Story do
  use Ecto.Schema

  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Schema.Story

  schema "stories" do
    field :title
    field :url
    field :comments_url
    field :points, :integer
    field :trending, :boolean
    timestamps
  end

  def changeset(story, params \\ %{}) do
    story
    |> Ecto.Changeset.cast(params, [:points, :trending])
  end

  def set_trending(stories) do
    stories_trending_besides(stories)
    |> Repo.update_all(set: [trending: false])
    stories
  end

  def save_all(stories) do
    stories
    |> Enum.map(&upsert/1)
  end

  defp upsert(struct) do
    case story = Repo.get(Story, struct.id) do
      nil ->
        struct
        |> Repo.insert!
      %Story{} ->
        story
        |> changeset(%{points: struct.points, trending: true})
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
