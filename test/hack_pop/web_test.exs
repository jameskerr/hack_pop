defmodule HackPop.WebTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts HackPop.Web.init([])

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(HackPop.Repo)
  end

  test "post /clients" do
    conn = conn(:post, "/clients", %{client_id: "123"})
           |> HackPop.Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == "{\"threshold\":300,\"client_id\":\"123\"}"
  end

  test "post /client/:client_id already exists" do
    {:ok, client } = HackPop.Repo.insert(%HackPop.Client{ client_id: "123", threshold: 300 })

    conn = conn(:post, "/clients", %{client_id: "123"})
           |> HackPop.Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert conn.resp_body == "{\"client_id\":[\"has already been taken\"]}"
  end
end
