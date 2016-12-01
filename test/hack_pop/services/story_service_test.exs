defmodule HackPop.Services.StoryServiceTest do
  use ExUnit.Case #, async: true
  use Timex

  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Schemas.Story
  alias HackPop.Services.StoryService

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "save_all with new data" do
    stories = [
      %Story{id: 1, title: "A", url: "a.com", points: 1},
      %Story{id: 2, title: "B", url: "b.com", points: 2},
      %Story{id: 3, title: "C", url: "c.com", points: 3},
    ]
    StoryService.save_all(stories)
    assert 3 == story_count
  end

  test "save_all with existing data" do
    stories = [
      %Story{id: 1, title: "A", url: "a.com", points: 1},
      %Story{id: 2, title: "B", url: "b.com", points: 2},
      %Story{id: 3, title: "C", url: "c.com", points: 3},
    ]
    StoryService.save_all(stories)

    updates = [%Story{id: 3, title: "C", url: "c.com", points: 100}]
    StoryService.save_all(updates)
    assert 3 == story_count

    updated_story = Story |> Repo.get(3)

    assert 100 == updated_story.points
  end

  defp story_count do
    from(s in Story, select: count(s.id)) |> Repo.one
  end
end
