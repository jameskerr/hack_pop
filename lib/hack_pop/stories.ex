defmodule HackPop.Stories do

  @name __MODULE__

  def start_link do
    Agent.start(fn -> %{} end, name: @name)
  end

  def get do
    Agent.get(@name, fn stories -> stories end)
  end

  def update(story) do
    Agent.update(@name, fn stories -> 
      if Map.has_key?(stories, story.url) do
        %{stories | story.url => story} 
      else
        Map.put(stories, story.url, story)
      end
    end)
  end

  def clear_all do
    Agent.update(@name, fn stories -> %{} end)
  end
end