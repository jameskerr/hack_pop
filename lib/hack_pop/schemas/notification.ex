defmodule HackPop.Schemas.Notification do
  use Ecto.Schema

  schema "notifications" do
    belongs_to :client, HackPop.Schemas.Client, type: :string
    belongs_to :story, HackPop.Schemas.Story
    field :read, :boolean, default: false
    timestamps
  end

  def changeset(notification, params \\ %{}) do
    notification
    |> Ecto.Changeset.cast(params, [:client_id, :story_id, :read])
  end
end
