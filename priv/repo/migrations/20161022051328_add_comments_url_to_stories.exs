defmodule HackPop.Repo.Migrations.AddCommentsUrlToStories do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      add :comments_url, :string
    end
  end
end
