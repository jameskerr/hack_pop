defmodule HackPop.Story do
  use Ecto.Schema

  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Story

  @derive {Poison.Encoder, only: [:id, :title, :url, :points]}
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

  def trending do
    trending_query
    |> Repo.all
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
    case story = find_recent(struct) do
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

  defp trending_query do
    from s in Story,
      where: s.trending == true,
      order_by: [desc: :points]
  end

  defp stories_trending_besides(stories) do
    from s in Story,
      where:  s.trending == true
      and not s.id in ^ids(stories)
  end

  defp find_recent(story) do
    story
    |> find_recent_query
    |> Repo.one
  end

  defp find_recent_query(story) do
    from s in Story,
      where: s.title == ^story.title
         and s.url   == ^story.url
         and s.inserted_at > datetime_add(^Ecto.DateTime.utc, -3, "day")
  end
end
