defmodule HackPop.Web do
  use Plug.Router

  import Ecto.Query, only: [from: 2, where: 2]

  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Story
  alias HackPop.Pusher
  alias HackPop.Notification
  alias HackPop.StoryNotification

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  #####################
  # STORIES
  #####################

  get "/stories" do
    send_resp conn, 200, Poison.encode!(Story.trending)
  end

  #####################
  # CLIENTS
  #####################

  post "/clients" do
    case Client.create(%{id: conn.params["client_id"]}) do
      {:ok,    client }   -> send_resp conn, 201, Poison.encode!(client)
      {:error, changeset} -> send_resp conn, 422, errors_json(changeset)
    end
  end

  put "/clients/:id" do
    case (
      Client.find(id)
      |> Client.changeset(%{threshold: conn.params["threshold"]})
      |> Repo.update
    ) do
      {:ok,    client}    -> send_resp conn, 204, Poison.encode!(client)
      {:error, changeset} -> send_resp conn, 422, errors_json(changeset)
    end
  end

  get "/clients/:id/test" do
    query = from s in Story, limit: 1, where: s.trending == true, order_by: fragment("RANDOM()")
    story = query |> Repo.one

    case client = Client.find(id) do
      %Client{} ->
        notification = %Notification{client_id: client.id, story_id: story.id, id: 0}

        message = APNS.Message.new
          |> Map.put(:token, client.id)
          |> Map.put(:alert, "#{story.title}\nPoints: #{story.points}")
          |> Map.put(:badge, 0)
          |> Map.put(:extra, StoryNotification.cast(story, notification) |> Map.from_struct)

        :ok = APNS.push(:dev_pool, message)

        send_resp conn, 200, "{\"fer_shur\": \"dude\"}"
      nil ->
        send_resp conn, 404, "No client with #{inspect(id)}"
    end
  end

  get "/clients/:client_id/notifications" do
    case client = Client.find(client_id) do
      %Client{} ->
        json = client
               |> Client.recent_unread_story_notifications
               |> Poison.encode!
        send_resp conn, 200, json
      nil ->
        send_resp conn, 404, "No client with #{inspect(client_id)}"
    end
  end

  put "/clients/:client_id/notifications/:id" do
    case client = Client.find(client_id) do
      %Client{} ->
        changeset = Notification
          |> where(client_id: ^client.id, id: ^id)
          |> Repo.one
          |> Notification.changeset(%{read: conn.params["read"]})

        case Repo.update(changeset) do
          {:ok,    client}    -> send_resp conn, 204, ""
          {:error, changeset} -> send_resp conn, 422, errors_json(changeset)
        end
      nil ->
        send_resp conn, 404, "No client with #{inspect(client_id)}"
    end
  end

  #####################
  # CATCH ALL
  #####################

  match _ do
    send_resp conn, 404, "Not Found"
  end

  #####################
  # HELPERS
  #####################

  defp errors_json(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(msg, "%{#{key}}", to_string(value))
      end)
    end) |> Poison.encode!
  end
end
