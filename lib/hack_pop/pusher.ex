require Logger

defmodule HackPop.Pusher do
  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Notification
  alias HackPop.StoryNotification

  import Ecto.Query

  def push_to_all_clients(stories) do
    clients = Client |> Repo.all

    Enum.each(clients, fn client ->
      Enum.each(stories, fn story ->
        if !already_sent?(client, story) && story.points >= client.threshold do
          push(story, client)
        end
      end)
    end)
  end

  def push(story, client) do
    notification = Repo.insert! %Notification{client_id: client.id, story_id: story.id}
    message = APNS.Message.new
      |> Map.put(:token, client.client_id)
      |> Map.put(:alert, story.title)
      |> Map.put(:badge, 0)
      |> Map.put(:extra, %{
        url:             story.url,
        notification_id: notification.id
        })
    :ok = APNS.push(:dev_pool, message)
  end

  defp already_sent?(client, story) do
    Notification |> where(client_id: ^client.id, story_id: ^story.id) |> Repo.one
  end
end
