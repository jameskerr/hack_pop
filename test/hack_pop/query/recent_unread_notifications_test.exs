defmodule HackPop.Query.RecentUnreadNotificationsTest do
  use ExUnit.Case, async: true

  alias HackPop.Repo
  alias HackPop.Schema.{Story, Client, Notification}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "recent_unread_story_notifications" do
    client        = Repo.insert! %Client{id: "123"}
    story         = Repo.insert! %Story{title: "title", url: "url", points: 100}
    _notification = Repo.insert! %Notification{client_id: client.id,
                                              story_id: story.id}

    assert 1 === HackPop.Query.RecentUnreadNotifications.get(client) |> length
  end

  test "recent_unread_story_notifications excludes unread" do
    client        = Repo.insert! %Client{id: "123"}
    _notification = Repo.insert! %Notification{client_id: client.id,
                                               story_id: 1,
                                               read: true}

    assert [] == HackPop.Query.RecentUnreadNotifications.get(client)
  end

  test "recent_unread_story_notifications exludes older than 5 days" do
    client       = Repo.insert! %Client{id: "123"}
    _notificaion = Repo.insert! %Notification{client_id: client.id,
                                               story_id: 1,
                                               inserted_at: Ecto.DateTime.cast!({{2016, 09, 01}, {0,0,0}})}

    assert [] == HackPop.Query.RecentUnreadNotifications.get(client)
  end
end
