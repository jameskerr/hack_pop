defmodule HackPop.HackerNews.ApiTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias HackPop.HackerNews.Api

  setup_all do
    HTTPoison.start
  end

  test "top_stories" do
    use_cassette "hackernews" do
      expected = %HackPop.Schemas.Story{
        id:     12955476,
        title:  "Apple's desensitisation of the human race to fundamental security practices",
        url:    "https://www.troyhunt.com/apples-desensitisation-of-the-human-race-to-fundamental-security-practices/",
        points: 60,
        comments_url: "item?id=12955476"
      }
      assert expected == hd(Api.get_top_stories)
    end
  end

  test "fetch_story when url is nil" do
    use_cassette "hackernews_story_12991490" do
      expected = %HackPop.Schemas.Story{
        id:     12991490,
        title:  "Upcall, an on-demand API Callforce, is hiring an Operations Manager",
        url:    "https://news.ycombinator.com/item?id=12991490",
        points: 1,
        comments_url: "item?id=12991490"
      }
      assert expected == Api.get_story(12991490)
    end
  end
end
