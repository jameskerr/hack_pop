defmodule HackPopTest.StoriesTest do
  use ExUnit.Case, async: true

  setup do
    HackPop.Stories.clear_all
  end

  test "get" do
    assert HackPop.Stories.get == %{}
  end

  test "update will add a new story" do
    story = %{url: "food.trucks", score: 10, title: "Food Trucks FTW"}
    HackPop.Stories.update(story)
    assert Map.equal?(HackPop.Stories.get["food.trucks"], story)
  end

  test "update changes existing story" do
    old_story = %{url: "food.trucks", score: 10, title: "Food Trucks FTW"}
    HackPop.Stories.update(old_story)
    new_story = %{url: "food.trucks", score: 200, title: "Food Trucks FTW"}
    HackPop.Stories.update(new_story)
    assert Map.equal?(HackPop.Stories.get["food.trucks"], new_story)
  end
end
