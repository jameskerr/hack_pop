defmodule HackPop.WebTest do
  use ExUnit.Case
  use Plug.Test

  import Ecto.Query, only: [where: 2]

  alias HackPop.Repo
  alias HackPop.Client
  alias HackPop.Web

  @opts Web.init([])

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "post /clients" do
    conn = conn(:post, "/clients", %{client_id: "123"})
           |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == "{\"threshold\":300,\"client_id\":\"123\"}"
  end

  test "post /clients already exists" do
    {:ok, _client } = Repo.insert(%Client{ client_id: "123", threshold: 300 })

    conn = conn(:post, "/clients", %{client_id: "123"})
           |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert conn.resp_body == "{\"client_id\":[\"has already been taken\"]}"
  end

  test "put /clients/:client_id" do
    {:ok, _client} = Repo.insert(%Client{ client_id: "123", threshold: 300 })

    conn = conn(:put, "/clients/123", %{threshold: 1000})
           |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 204

    client = Client |> where(client_id: "123") |> Repo.one
    assert client.threshold == 1000
  end
end
