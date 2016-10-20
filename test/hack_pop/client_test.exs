defmodule HackPop.ClientTest do
  use ExUnit.Case

  alias HackPop.Repo
  alias HackPop.Notification
  alias HackPop.Client
  alias HackPop.Story

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "find when exists" do
    Repo.insert! %Client{client_id: "123", threshold: 300}

    assert Client.find("123").client_id == "123"
  end

  test "find when does not exist" do
    assert Client.find("123") == nil
  end

  test "recent_unread_story_notifications" do
    client        = Repo.insert! %Client{client_id: "123"}
    story         = Repo.insert! %Story{title: "title", url: "url", points: 100}
    _notification = Repo.insert! %Notification{client_id: client.id,
                                              story_id: story.id}

    assert 1 === Client.recent_unread_story_notifications(client) |> length
  end

  test "recent_unread_story_notifications excludes unread" do
    client        = Repo.insert! %Client{client_id: "123"}
    _notification = Repo.insert! %Notification{client_id: client.id,
                                               story_id: 1,
                                               read: true}

    assert [] == Client.recent_unread_story_notifications(client)
  end

  test "recent_unread_story_notifications exludes older than 5 days" do
    client       = Repo.insert! %Client{client_id: "123"}
    _notificaion = Repo.insert! %Notification{client_id: client.id,
                                               story_id: 1,
                                               inserted_at: Ecto.DateTime.cast!({{2016, 09, 01}, {0,0,0}})}

    assert [] == Client.recent_unread_story_notifications(client)
  end
end
