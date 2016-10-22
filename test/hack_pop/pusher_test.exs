defmodule HackPopTest.PusherTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Pusher
  alias HackPop.Story
  alias HackPop.Client
  alias HackPop.Notification

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "push_to_all_clients when not already sent" do
    stories = [ %Story{title: "Dinosaurs!", points: 301, id: 1} ]
    client  = Repo.insert!(%Client{id: "123", threshold: 300})
    Pusher.push_to_all_clients(stories)

    assert Notification
           |> where(client_id: ^client.id, story_id: 1)
           |> Repo.one
  end

  test "push_to_all_clients when already sent" do
    stories  = [ %Story{title: "Dinosaurs!", points: 301, id: 1} ]
    _client  = Repo.insert!(%Client{id: "123", threshold: 300})
    Pusher.push_to_all_clients(stories)

    before_count = notification_count
    Pusher.push_to_all_clients(stories)

    assert before_count == notification_count
  end

  test "push_to_all_clients when below threshold" do
    stories = [ %Story{title: "Dinosaurs!", points: 299, id: 1} ]
    _client = Repo.insert!(%Client{id: "123", threshold: 300})

    before_count = notification_count()
    Pusher.push_to_all_clients(stories)
    assert before_count == notification_count
  end

  defp notification_count do
    Repo.one from n in Notification, select: count(n.id)
  end
end
