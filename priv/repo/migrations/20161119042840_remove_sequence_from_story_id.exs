defmodule HackPop.Repo.Migrations.RemoveSequenceFromStoryId do
  use Ecto.Migration

  def up do
    execute "ALTER SEQUENCE stories_id_seq OWNED BY NONE"
    execute "ALTER TABLE stories ALTER COLUMN id DROP DEFAULT"
    execute "DROP SEQUENCE stories_id_seq"
  end

  def down do
  end
end
