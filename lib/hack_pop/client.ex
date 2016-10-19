defmodule HackPop.Client do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Notification

  @derive { Poison.Encoder, only: [:client_id, :threshold] }
  schema "clients" do
    field :client_id
    field :threshold, :integer, default: 300
    timestamps
  end

  def changeset(client, params \\ %{}) do
    client
    |> cast(params, [:client_id, :threshold])
    |> unique_constraint(:client_id)
  end

  def find(client_id) do
    Client |> where(client_id: ^client_id) |> Repo.one
  end

  def recent_unread_notifications(client) do
    notifications = from(
      n in Notification,
        where: n.client_id   == ^client.id
          and  n.read        == false
          and  n.inserted_at >= ago(5, "day"),
        limit: 15,
        preload: [:story]
    ) |> Repo.all

    Enum.map(notifications, fn notification ->
      HackPop.StoryNotification.cast(notification.story, notification)
    end)
  end
end
