defmodule HackPop.Story do
  use Ecto.Schema
  import Ecto.Query
  alias HackPop.Repo
  alias HackPop.Story

  schema "stories" do
    field :title
    field :url
    field :points, :integer
    field :trending, :boolean
    timestamps
  end

  def changeset(story, params \\ %{}) do
    story
    |> Ecto.Changeset.cast(params, [:points])
  end

  def save_all(stories) do
    stories
    |> Enum.map(&upsert/1)
  end

  defp upsert(story) do
    exists = Story
    |> where(title: ^story.title, url: ^story.url)
    |> first
    |> Repo.one

    case exists do
      nil ->
        Repo.insert(story)
      %Story{} ->
        Repo.update(Story.changeset(exists, %{points: story.points}))
    end
  end
end
