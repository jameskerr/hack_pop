defmodule HackPop.HackerNews.StoryTest do
  use ExUnit.Case #, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias HackPop.HackerNews.Story

  setup_all do
    HTTPoison.start
  end

  test "fetch_story when url is nil" do
    use_cassette "hackernews_story_12991490" do
      expected = %HackPop.Schema.Story{
        id:     12991490,
        title:  "Upcall, an on-demand API Callforce, is hiring an Operations Manager",
        url:    "https://news.ycombinator.com/item?id=12991490",
        points: 1,
        comments_url: "item?id=12991490"
      }
      assert expected == Story.get(12991490)
    end
  end
end
