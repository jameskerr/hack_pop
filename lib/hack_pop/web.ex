defmodule HackPop.Web do
  use Plug.Router
  use Plugsnag

  import Ecto.Query, only: [where: 2]

  alias HackPop.Repo
  alias HackPop.Schemas.Client
  alias HackPop.Schemas.Story
  alias HackPop.Schemas.Notification
  alias HackPop.Pinger
  alias HackPop.Views.{ClientView, StoryView}

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug Plug.Logger, log: :info
  plug :match
  plug :dispatch

  #####################
  # STORIES
  #####################

  get "/stories" do
    stories =
      HackPop.Queries.TrendingStories.get
      |> StoryView.cast
      |> to_json

    send_resp conn, 200, stories
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
    case HackPop.Services.ClientService.create(%{id: conn.params["client_id"]}) do
      {:ok,    client }   -> send_resp conn, 201, client |> ClientView.cast |> to_json
      {:error, changeset} -> send_resp conn, 422, errors_json(changeset)
    end
  end

  put "/clients/:id" do
    case (
      Repo.get(Client, id)
      |> Client.changeset(%{threshold: conn.params["threshold"]})
      |> Repo.update
    ) do
      {:ok,    client}    -> send_resp conn, 204, client |> ClientView.cast |> to_json
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
    |> HackPop.Services.PushService.push
    send_resp conn, 200, "{\"fer_shur\": \"dude\"}"
  end

  get "/clients/:client_id/notifications" do
    case client = Repo.get(Client, client_id) do
      %Client{} ->
        notifications =
          client
          |> HackPop.Queries.RecentUnreadNotifications.get
          |> HackPop.Views.NotificationView.cast
          |> to_json
        send_resp conn, 200, notifications
      nil ->
        send_resp conn, 404, "No client with #{inspect(client_id)}"
    end
  end

  put "/clients/:client_id/notifications/:id" do
    case client = Repo.get(Client, client_id) do
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

  get "/clients/:client_id/notifications/:id" do
    Repo.get!(Client, client_id)

    notification =
      Repo.get(Notification, id)
      |> Repo.preload(:story)
      |> HackPop.Views.NotificationView.cast
      |> to_json

    send_resp conn, 200, notification
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

  defp to_json(data) do
    Poison.encode! data
  end

  defp errors_json(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, _acc ->
        String.replace(msg, "%{#{key}}", to_string(value))
      end)
    end) |> Poison.encode!
  end
end
