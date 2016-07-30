defmodule HackPopTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest HackPop

  setup_all do
    HTTPoison.start
    HackPop.Stories.clear_all
  end

  test "ping saves the stories" do
    use_cassette "hackernews" do
      HackPop.ping
    end
    stories = HackPop.Stories.get
    assert (stories |> Map.keys |> length) == 3
  end
end
