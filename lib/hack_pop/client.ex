defmodule HackPop.Client do
  use Ecto.Schema
  import Ecto.Changeset

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

  def insert do
  end
end
