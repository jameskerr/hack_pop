defmodule HackPop.Schemas.Client do
  use Ecto.Schema

  import Ecto.Changeset

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
end
