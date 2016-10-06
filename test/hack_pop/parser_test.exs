defmodule HackPopTest.ParserTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "find_stories parses title" do
    use_cassette "hackernews" do
      {:ok, response} = HTTPoison.get("https://news.ycombinator.com/")
      stories = HackPop.Parser.find_stories(response.body)
      expected = %HackPop.Story{
        title:  "Israel Proves the Desalination Era Is Here",
        url:    "http://www.scientificamerican.com/article/israel-proves-the-desalination-era-is-here/",
        points: 136
      }
      assert expected == hd(stories)
    end
  end
end
