defmodule HackPop.Views.NotificationViewTest do
  use ExUnit.Case, async: true

  alias HackPop.Views.NotificationView

  test "cast" do
    notification = %HackPop.Schemas.Notification{
      id: 10,
      story: %HackPop.Schemas.Story{
        title: "title",
        url:   "url",
        comments_url: "comments_url",
        id: 1,
        points: 1000
      }
    }

    sn = NotificationView.cast(notification)

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
