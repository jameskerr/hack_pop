defmodule HackPop.HackerNews.HTTPClient do
  def top_stories do
    HTTPoison.get "https://hacker-news.firebaseio.com/v0/topstories.json"
  end

  def story(id) do
    HTTPoison.get "https://hacker-news.firebaseio.com/v0/item/#{id}.json"
  end
end
