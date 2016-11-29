defmodule HackPop.Schemas.Story do
  use Ecto.Schema

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
end
