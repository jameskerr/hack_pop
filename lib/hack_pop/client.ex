defmodule HackPop.Client do
  use Ecto.Schema

  schema "clients" do
    field :client_id
    field :threshold, :integer
    timestamps
  end
end
