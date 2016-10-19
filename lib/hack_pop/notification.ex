defmodule HackPop.Notification do
  use Ecto.Schema

  @derive {Poison.Encoder, only: [:id, :story, :read]}
  schema "notifications" do
    belongs_to :client, HackPop.Client
    belongs_to :story, HackPop.Story
    field :read, :boolean, default: false
    timestamps
  end

  def changeset(notification, params \\ %{}) do
    notification
    |> Ecto.Changeset.cast(params, [:client_id, :story_id, :read])
  end
end
