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
    query = from s in Story,
      where: s.title == ^story.title and
             s.url   == ^story.url   and
             s.inserted_at > datetime_add(^Ecto.DateTime.utc, -3, "day")

    exists = Repo.one(query)

    case exists do
      nil ->
        Repo.insert(story)
      %Story{} ->
        Repo.update(Story.changeset(exists, %{points: story.points}))
    end
  end
end
