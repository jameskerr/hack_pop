require Logger

defmodule HackPop.Pusher do
  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Notification

  import Ecto.Query

  def push_to_all_clients(stories) do
    IO.inspect clients = Client |> Repo.all
    IO.inspect stories

    Enum.each(clients, fn client ->
      Enum.each(stories, fn story ->
        if !already_sent?(client, story) && story.points >= client.threshold do
          push(story, client)
        end
      end)
    end)
  end

  def push(story, client) do
    message = APNS.Message.new
      |> Map.put(:token, client.client_id)
      |> Map.put(:alert, "#{story.title}\nPoints: #{story.points}")
      |> Map.put(:badge, 0)
      |> Map.put(:"content-available", 1)
      |> Map.put(:extra, %{
        url: story.url,
        points: story.points
      })

    case APNS.push(:dev_pool, message) do
      :ok ->
        Repo.insert %Notification{client_id: client.id, story_id: story.id, status: 1}
    end
  end

  def push_test(story, client_id) do
    message = APNS.Message.new
      |> Map.put(:token, client_id)
      |> Map.put(:alert, "#{story.title}\nPoints: #{story.points}")
      |> Map.put(:badge, 0)
      |> Map.put(:extra, %{
        title:  story.title,
        url:    story.url,
        comments_url: nil,
        points: story.points
      })
      APNS.push(:dev_pool, message)
  end

  def error(error, _) do
    Logger.error inspect(error)
  end

  defp already_sent?(client, story) do
    Notification |> where(client_id: ^client.id, story_id: ^story.id) |> Repo.one
  end
end
