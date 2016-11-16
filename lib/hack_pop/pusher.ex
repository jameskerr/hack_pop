require Logger

defmodule HackPop.Pusher do
  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Notification

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

  def push(notification) do
    message = construct_message(notification)
    :ok = APNS.push(:dev_pool, message)
  end

  defp create_notification(story, client) do
    %Notification{story_id: story.id, client_id: client.id}
    |> Repo.insert!
    |> Repo.preload(:story)
  end

  defp construct_message(notification) do
    APNS.Message.new
    |> Map.put(:token, notification.client_id)
    |> Map.put(:alert, notification.story.title)
    |> Map.put(:badge, 0)
    |> Map.put(:extra, %{
      url: notification.story.url,
      id:  notification.id,
      comments_url: notification.story.comments_url
      })
  end

  defp already_sent?(client, story) do
    Notification |> where(client_id: ^client.id, story_id: ^story.id) |> Repo.one
  end
end
