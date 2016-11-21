defmodule HackPop.WebTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Ecto.Query, only: [where: 2]

  alias HackPop.Repo
  alias HackPop.Schema.Client
  alias HackPop.Web
  alias HackPop.Schema.Notification
  alias HackPop.Schema.Story

  @opts Web.init([])

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "get /stories when trending" do
    Repo.insert! %Story{title: "A", url: "a.com", comments_url: "item?id=a", points: 1, trending: true}

    conn = conn(:get, "/stories") |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body |> Poison.decode! |> length == 1
  end

  test "get /stories when not trending" do
    Repo.insert! %Story{title: "A", url: "a.com", comments_url: "item?id=a", points: 1, trending: false}

    conn = conn(:get, "/stories") |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "[]"
  end

  test "post /clients" do
    conn = conn(:post, "/clients", %{client_id: "123"}) |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == "{\"threshold\":300,\"id\":\"123\"}"
  end

  test "post /clients already exists" do
    {:ok, _client } = Repo.insert %Client{id: "123", threshold: 300}

    conn = conn(:post, "/clients", %{client_id: "123"})
           |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert conn.resp_body == "{\"id\":[\"has already been taken\"]}"
  end

  test "put /clients/:client_id" do
    {:ok, _client} = Repo.insert(%Client{id: "123", threshold: 300})

    conn = conn(:put, "/clients/123", %{threshold: 1000})
           |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 204

    client = Client |> where(id: "123") |> Repo.one
    assert client.threshold == 1000
  end

  test "get /clients/:client_id/notifications 404" do
    url  = "/clients/123/notifications"
    conn = conn(:get, url) |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end


  test "get /clients/:client_id/notifications 200" do
    client        = Repo.insert! %Client{id: "123"}
    story         = Repo.insert! %Story{title: "Sup", url: "hi", comments_url: "item?id=12191089", points: 100}
    _notification = Repo.insert! %Notification{client_id: client.id,
                                               story_id: story.id}
    url  = "/clients/123/notifications"
    conn = conn(:get, url) |> Web.call(@opts)

    response = Poison.Parser.parse!(conn.resp_body)

    assert conn.state  == :sent
    assert conn.status == 200
    assert response |> Enum.map(&Map.keys/1) |> List.flatten == ["comments_url", "notification_id", "points", "story_id", "title", "url"]
  end

  test "put /clients/:client_id/notifications/:id updates read" do
    client       = Repo.insert! %Client{id: "123"}
    story        = Repo.insert! %Story{title: "Sup", url: "hi", points: 100}
    notification = Repo.insert! %Notification{client_id: client.id,
                                              story_id: story.id}

    url  = "/clients/123/notifications/#{notification.id}"
    conn = conn(:put, url, %{read: true}) |> Web.call(@opts)

    assert conn.state  == :sent
    assert conn.status == 204

    notification = Notification
      |> where(id: ^notification.id)
      |> Repo.one

    assert notification.read == true
  end

  test "put /clients/:client_id/notifications/:id with bad client_id" do
    url  = "/clients/888/notifications/888"
    conn = conn(:put, url, %{read: true}) |> Web.call(@opts)

    assert conn.state  == :sent
    assert conn.status == 404
  end
end
