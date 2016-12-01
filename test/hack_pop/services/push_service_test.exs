defmodule HackPop.Services.PushServiceTest do
  use ExUnit.Case, aysnc: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import Ecto.Query

  alias HackPop.Repo
  alias HackPop.Services.PushService
  alias HackPop.Schemas.Story
  alias HackPop.Schemas.Client
  alias HackPop.Schemas.Notification

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "push message format" do
    PushService.push %Notification{id: 1, client_id: "abc", story: %Story{title: "Fucking yeah!"}}

    assert_received {:ok, message}
    assert message.token == "abc"
    assert message.alert == "Fucking yeah!"
    assert message.extra == %{id: 1}
  end

  test "push_to_all_clients when not already sent" do
    story  = Repo.insert!(%Story{id: 1, title: "Dinosaurs!", points: 301, url: "awesome.com"})
    client = Repo.insert!(%Client{id: "123", threshold: 300})

    PushService.push_to_all_clients([story])

    assert Notification
           |> where(client_id: ^client.id, story_id: ^story.id)
           |> Repo.one
  end

  test "push_to_all_clients when already sent" do
    story   = Repo.insert! %Story{id: 1, title: "Dinosaurs!", points: 301, url: "sheit.com"}
    _client = Repo.insert!(%Client{id: "123", threshold: 300})

    PushService.push_to_all_clients([story])
    before_count = notification_count
    PushService.push_to_all_clients([story])

    assert before_count == notification_count
  end

  test "push_to_all_clients when below threshold" do
    stories = [ %Story{title: "Dinosaurs!", points: 299, id: 1} ]
    _client = Repo.insert!(%Client{id: "123", threshold: 300})

    before_count = notification_count()
    PushService.push_to_all_clients(stories)
    assert before_count == notification_count
  end

  defp notification_count do
    Repo.one from n in Notification, select: count(n.id)
  end
end
