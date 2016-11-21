defmodule HackPop.Pusher do
  alias HackPop.Repo
  alias HackPop.Schema.Client
  alias HackPop.Schema.Notification

  import Ecto.Query

  def push_to_all_clients(stories) do
    clients = Client |> Repo.all

    Enum.each(clients, fn client ->
      Enum.each(stories, fn story ->
        if !already_sent?(client, story) && story.points >= client.threshold do
          story
          |> create_notification(client)
          |> push
        end
      end)
    end)
  end

  def push(notification, opts \\ [sync: false]) do
    notification
    |> HackPop.APNS.Message.from_notification
    |> HackPop.APNS.Client.push(opts)
  end

  defp create_notification(story, client) do
    %Notification{story_id: story.id, client_id: client.id}
    |> Repo.insert!
    |> Repo.preload(:story)
  end

  defp already_sent?(client, story) do
    Notification |> where(client_id: ^client.id, story_id: ^story.id) |> Repo.one
  end
end
