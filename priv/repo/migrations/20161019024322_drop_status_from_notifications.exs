defmodule HackPop.Repo.Migrations.DropStatusFromNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      remove :status
    end
  end
end
