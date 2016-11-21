defmodule HackPop.Schema.Notification do
  use Ecto.Schema

  schema "notifications" do
    belongs_to :client, HackPop.Schema.Client, type: :string
    belongs_to :story, HackPop.Schema.Story
    field :read, :boolean, default: false
    timestamps
  end

  def changeset(notification, params \\ %{}) do
    notification
    |> Ecto.Changeset.cast(params, [:client_id, :story_id, :read])
  end
end
