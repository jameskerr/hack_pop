defmodule HackPop.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :title, :text, null: false
      add :url, :text, null: false
      add :points, :integer, null: false, default: 0
      add :trending, :boolean, null: false, default: true
      timestamps()
    end
  end
end
