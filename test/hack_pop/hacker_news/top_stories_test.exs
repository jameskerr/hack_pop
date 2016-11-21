defmodule HackPop.HackerNews.TopStoriesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias HackPop.HackerNews.TopStories

  setup_all do
    HTTPoison.start
  end

  test "top_stories" do
    use_cassette "hackernews" do
      expected = %HackPop.Schema.Story{
        id:     12955476,
        title:  "Apple's desensitisation of the human race to fundamental security practices",
        url:    "https://www.troyhunt.com/apples-desensitisation-of-the-human-race-to-fundamental-security-practices/",
        points: 60,
        comments_url: "item?id=12955476"
      }
      assert expected == hd(TopStories.get)
    end
  end
end
