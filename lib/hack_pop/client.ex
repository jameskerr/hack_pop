defmodule HackPop.Client do
  use Ecto.Schema

  @derive { Poison.Encoder, only: [:client_id, :threshold] }
  schema "clients" do
    field :client_id
    field :threshold, :integer
    timestamps
  end

  def insert do
  end
end
