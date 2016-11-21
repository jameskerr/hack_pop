defmodule HackPop.Views.NotificationViewTest do
  use ExUnit.Case

  alias HackPop.Views.NotificationView

  test "cast" do
    story = %HackPop.Schema.Story{
      title: "title",
      url:   "url",
      comments_url: "comments_url",
      id: 1,
      points: 1000
    }

    notification = %HackPop.Schema.Notification{id: 10}

    sn = NotificationView.cast(story, notification)

    assert sn == %NotificationView{
      title: "title",
      url: "url",
      notification_id: 10,
      points: 1000,
      story_id: 1,
      comments_url: "comments_url"
    }
  end
end
