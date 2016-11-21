defmodule HackPop.Schema.Client do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Schema.Client
  alias HackPop.Schema.Notification
  alias HackPop.Views.NotificationView

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

  def create(params \\ %{}) do
    %Client{}
    |> changeset(params)
    |> Repo.insert
  end
end
