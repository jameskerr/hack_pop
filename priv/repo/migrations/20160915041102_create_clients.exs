defmodule HackPop.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :client_id, :string, null: false
      add :threshold, :integer, null: false, default: 300
      timestamps()
    end
  end
end
