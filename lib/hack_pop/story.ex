defmodule HackPop.Story do
  use Ecto.Schema
  import Ecto.Query
  alias HackPop.Repo
  alias HackPop.Story

  @derive {Poison.Encoder, only: [:title, :url, :points]}
  schema "stories" do
    field :title
    field :url
    field :points, :integer
    field :trending, :boolean
    timestamps
  end

  def changeset(story, params \\ %{}) do
    story
    |> Ecto.Changeset.cast(params, [:points, :trending])
  end

  def set_trending(stories) do
    ids   = Enum.map(stories, fn story -> story.id end)
    from(s in Story, where: not s.id in ^ids and s.trending == true)
    |> Repo.update_all(set: [trending: false])
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

    {:ok, story} =  case exists do
                      nil ->
                        Repo.insert(story)
                      %Story{} ->
                        Repo.update(Story.changeset(exists, %{points: story.points, trending: true}))
                    end
    story
  end
end
