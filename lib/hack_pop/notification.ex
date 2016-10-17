defmodule HackPop.Notification do
  use Ecto.Schema

  schema "notifications" do
    belongs_to :client, HackPop.Client
    belongs_to :story, HackPop.Story
    field :status, :integer
    timestamps
  end

  def changeset(notification, params \\ %{}) do
    notification
    |> Ecto.Changeset.cast(params, [:client_id, :story_id, :status])
  end
end