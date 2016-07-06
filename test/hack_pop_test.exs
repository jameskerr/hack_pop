defmodule HackPopTest do
  use ExUnit.Case
  doctest HackPop

  test "request" do
    IO.inspect HackPop.request
  end
end
