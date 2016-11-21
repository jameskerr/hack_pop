require Logger

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
    |> construct_message
    |> push_to_pool(opts)
  end

  defp push_to_pool(message, sync: false) do
    APNS.push_sync(pool, message)
  end

  defp push_to_pool(message, sync: true) do
    APNS.push(pool, message)
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

  defp pool do
    Application.get_env(:hack_pop, :apns_pool)
  end

  # A custom Error struct to pass to bugsnag
  defmodule APNSError do
    defexception [:message]
  end

  # Error Callback for the APNS server
  def error(error, token) do
    try do
      raise __MODULE__.APNSError, error.error
    rescue
      e -> Bugsnag.report(e, metadata: %{details: error, token: %{token: token}})
    end
  end

  def feedback(feedback) do
    Logger.info inspect(feedback)
  end
end
