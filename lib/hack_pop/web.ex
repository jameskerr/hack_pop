defmodule HackPop.Web do
  use Plug.Router
  use Plugsnag

  import Ecto.Query, only: [from: 2, where: 2]

  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Story
  alias HackPop.Notification
  alias HackPop.StoryNotification
  alias HackPop.Pinger


  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug Plug.Logger, log: :info
  plug :match
  plug :dispatch

  #####################
  # STORIES
  #####################

  get "/stories" do
    send_resp conn, 200, Poison.encode!(Story.trending)
  end

  #####################
  # PINGER
  #####################

  get "/pinger" do
    Task.start Pinger, :ping, []
    send_resp conn, 200, "pinger pinged" 
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
    story = %Story{
      title: "test", 
      url: "https://www.helloworld.com/",
      points: 10001
    }
    %Notification{story: story, client_id: id} 
    |> Pusher.push
    send_resp conn, 200, "{\"fer_shur\": \"dude\"}"
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
          {:ok,    _client}   -> send_resp conn, 204, ""
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
      Enum.reduce(opts, msg, fn {key, value}, _acc ->
        String.replace(msg, "%{#{key}}", to_string(value))
      end)
    end) |> Poison.encode!
  end
end
