defmodule HackPop.StoryNotificationTest do
  use ExUnit.Case

  alias HackPop.StoryNotification

  test "cast" do
    story = %HackPop.Story{
      title: "title",
      url:   "url",
      comments_url: "comments_url",
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
      story_id: 1,
      comments_url: "comments_url"
    }
  end
end
