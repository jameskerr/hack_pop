defmodule HackPop.Repo.Migrations.AddNotificationsTable do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :client_id, :integer, null: false
      add :story_id,  :integer, null: false
      add :status,    :integer, null: false
      timestamps()
    end

    create unique_index(:notifications, [:client_id, :story_id])
  end
end
