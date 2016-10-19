defmodule HackPop.Repo.Migrations.AddReadToNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :read, :boolean, default: false, null: false
    end
  end
end
