defmodule HackPop.WebTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts HackPop.Web.init([])

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(HackPop.Repo)
  end

  test "post /client/:client_id" do
    conn = conn(:post, "/clients/123")
    conn = HackPop.Web.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == "{\"threshold\":300,\"client_id\":\"123\"}"
  end
end
