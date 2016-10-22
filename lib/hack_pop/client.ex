defmodule HackPop.Client do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Notification
  alias HackPop.StoryNotification

  @derive { Poison.Encoder, only: [:id, :threshold] }
  @primary_key {:id, :string, autogenerate: false}
  schema "clients" do
    field :threshold, :integer, default: 300
    timestamps
  end

  def changeset(client, params \\ %{}) do
    client
    |> cast(params, [:id, :threshold])
    |> unique_constraint(:id, name: "clients_pkey")
  end

  def find(id) do
    Client
    |> where(id: ^id)
    |> Repo.one
  end

  def create(params \\ %{}) do
    %Client{}
    |> changeset(params)
    |> Repo.insert
  end

  def update(params \\ %{}) do

  end

  def recent_unread_story_notifications(client) do
    recent_unread_notifications_query(client)
    |> Repo.all
    |> Enum.map(&StoryNotification.from_notification/1)
  end

  defp recent_unread_notifications_query(client) do
    from n in Notification,
      where:    n.client_id   == ^client.id
        and     n.read        == false
        and     n.inserted_at >= ago(5, "day"),
      limit:    15,
      order_by: [desc: :inserted_at],
      preload:  [:story]
  end
end
