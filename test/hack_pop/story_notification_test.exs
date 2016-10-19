defmodule HackPop.StoryNotificationTest do
  use ExUnit.Case

  alias HackPop.StoryNotification

  test "cast" do
    story = %HackPop.Story{
      title: "title",
      url:   "url",
      id: 1,
      points: 1000
    }

    notification = %HackPop.Notification{id: 10}

    sn = StoryNotification.cast(story, notification)

    assert sn == %StoryNotification{
      title: "title",
      url: "url",
      notification_id: 10,
      points: 1000,
      story_id: 1
    }

    json = "{\"url\":\"url\",\"title\":\"title\",\"story_id\":1,\"points\":1000,\"notification_id\":10}"
    assert json == Poison.encode!(sn)
  end
end
