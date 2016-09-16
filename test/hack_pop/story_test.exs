
defmodule HackPop.StoryTest do
  use ExUnit.Case, async: true
  use Timex

  import Ecto.Query
  alias HackPop.Repo
  alias HackPop.Story

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "save_all with new data" do
    stories = [
      %HackPop.Story{title: "A", url: "a.com", points: 1},
      %HackPop.Story{title: "B", url: "b.com", points: 2},
      %HackPop.Story{title: "C", url: "c.com", points: 3},
    ]
    HackPop.Story.save_all(stories)
    assert 3 == story_count
  end

  test "save_all with existing data" do
    stories = [
      %HackPop.Story{title: "A", url: "a.com", points: 1},
      %HackPop.Story{title: "B", url: "b.com", points: 2},
      %HackPop.Story{title: "C", url: "c.com", points: 3},
    ]
    Story.save_all(stories)

    updates = [%HackPop.Story{title: "C", url: "c.com", points: 100}]
    Story.save_all(updates)
    assert 3 == story_count

    updated_story = Story
                    |> where(title: "C", url: "c.com")
                    |> first
                    |> Repo.one
    assert 100 == updated_story.points
  end

    test "save_all with existing data but over 72 hours old" do
    four_days_ago = Timex.shift(Timex.now, days: -3, hours: -1)
                     |> Timex.to_erl
                     |> Ecto.DateTime.from_erl

    [%Story{ title: "A", url: "a.com", points: 1, inserted_at: four_days_ago }]
    |> Story.save_all

    [%Story{ title: "A", url: "a.com", points: 100 }]
    |> Story.save_all

    assert 2 == story_count
  end

  defp story_count do
    from(s in Story, select: count(s.id)) |> HackPop.Repo.one
  end
end
