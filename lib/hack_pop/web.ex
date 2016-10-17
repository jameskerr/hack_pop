defmodule HackPop.Web do
  use Plug.Router
  import Ecto.Query, only: [from: 2, where: 2]

  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Story
  alias HackPop.Pusher

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

  get "/stories" do
    query = from s in Story, where:    s.trending == true,
                                     order_by: [desc: :points]
    stories = query |> Repo.all |> Poison.encode!
    send_resp conn, 200, stories
  end

  post "/clients" do
    params    = %{client_id: conn.params["client_id"]}
    changeset = Client.changeset(%Client{}, params)

    case Repo.insert(changeset) do
      {:ok,    client }   -> send_resp conn, 201, Poison.encode!(client)
      {:error, changeset} ->

        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(msg, "%{#{key}}", to_string(value))
          end)
        end)
        send_resp conn, 422, Poison.encode!(errors)
    end
  end

  put "/clients/:client_id" do
    client    = Client |> where(client_id: ^client_id) |> Repo.one
    changeset = Client.changeset(client, %{threshold: conn.params["threshold"]})

    case Repo.update(changeset) do
      {:ok, _} -> send_resp conn, 204, ""
      {:error, changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(msg, "%{#{key}}", to_string(value))
          end)
        end)
        send_resp conn, 422, Poison.encode!(errors)
    end
  end

  get "/clients/:client_id/test" do
    query = from s in Story, limit: 1, where: s.trending == true, order_by: fragment("RANDOM()")
    story = query |> Repo.one
    Pusher.push_test(story, client_id)
    send_resp conn, 200, "{\"fer_shur\": \"dude\"}"
  end

  match _ do
    send_resp conn, 404, "Not Found"
  end
end
