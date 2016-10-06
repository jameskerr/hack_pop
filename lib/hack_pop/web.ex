defmodule HackPop.Web do
  use Plug.Router
  import Ecto.Query, only: [from: 2]

  plug :match
  plug :dispatch

  get "/stories" do
    query = from s in HackPop.Story, where:    s.trending == true,
                                     order_by: [desc: :points]
    stories = query |> HackPop.Repo.all |> Poison.encode!
    send_resp conn, 200, stories
  end

  post "/clients/:client_id" do
    {:ok, client } = HackPop.Repo.insert %HackPop.Client{ client_id: client_id, threshold: 300 }
    send_resp conn, 201, Poison.encode!(client)
  end

  get "/clients/:client_id/test" do
    query = from s in HackPop.Story, limit: 1,
                                     where: s.trending == true
    story = query |> HackPop.Repo.one
    HackPop.Pusher.push(story, client_id)
    send_resp conn, 200, "{\"fer_shur\": \"dude\"}"
  end

  match _ do
    send_resp conn, 404, "Not Found"
  end
end
