defmodule HackPop.Repo.Migrations.UniqueClientId do
  use Ecto.Migration

  def change do
    create unique_index(:clients, [:client_id])
  end
end
