defmodule HackPopTest.ParserTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "find_stories parses title" do
    use_cassette "hackernews" do
      stories  = HackPop.Parser.find_stories "[12955476, 12955457, 12955445]"
      expected = %HackPop.Story{
        title:  "Apple's desensitisation of the human race to fundamental security practices",
        url:    "https://www.troyhunt.com/apples-desensitisation-of-the-human-race-to-fundamental-security-practices/",
        points: 60,
        comments_url: "item?id=12955476"
      }
      assert expected == hd(stories)
    end
  end
end
