defmodule HackPopTest.ParserTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "find_stories" do
    use_cassette "hackernews" do
      {:ok, response} = HTTPoison.get("https://news.ycombinator.com/")
      stories = HackPop.Parser.find_stories(response.body)
      first = hd(stories)
      assert first.title == "After 100 years World War I battlefields are poisoned and uninhabitable" 
      assert first.url   == "http://www.wearethemighty.com/articles/after-100-years-world-war-i-battlefields-are-poisoned-and-uninhabitable"
      assert first.score == 377
    end
  end
end