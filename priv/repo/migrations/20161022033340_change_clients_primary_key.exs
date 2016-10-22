defmodule HackPop.Repo.Migrations.ChangeClientsPrimaryKey do
  use Ecto.Migration

  def up do
    # Changes for the clients table
    drop constraint(:clients, "clients_pkey")
    drop unique_index(:clients, [:client_id])

    alter table(:clients) do
      remove :id
    end

    rename table(:clients), :client_id, to: :id

    alter table(:clients) do
      modify :id, :string, primary_key: true
    end

    # Changes for the associated notifications table
    alter table(:notifications) do
      modify :client_id, :string
    end
  end

  def down do
  end
end
