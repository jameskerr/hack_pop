defmodule HackPop.Schema.StoryNotificationTest do
  use ExUnit.Case

  alias HackPop.Schema.StoryNotification

  test "cast" do
    story = %HackPop.Schema.Story{
      title: "title",
      url:   "url",
      comments_url: "comments_url",
      id: 1,
      points: 1000
    }

    notification = %HackPop.Schema.Notification{id: 10}

    sn = StoryNotification.cast(story, notification)

    assert sn == %StoryNotification{
      title: "title",
      url: "url",
      notification_id: 10,
      points: 1000,
      story_id: 1,
      comments_url: "comments_url"
    }
  end
end
