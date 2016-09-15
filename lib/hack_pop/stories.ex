require Logger

defmodule HackPop.Stories do

  @name __MODULE__

  def start_link do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def get do
    Agent.get(@name, fn stories -> stories end)
  end

  def update(story) do
    Agent.update(@name, fn stories ->
      if Map.has_key?(stories, story.url) do
        Logger.info "Updating story: #{inspect story}"
        %{stories | story.url => story}
      else
        Logger.info "Adding story: #{inspect story}"
        Map.put(stories, story.url, story)
      end
    end)
  end

  def clear_all do
    Agent.update(@name, fn stories -> %{} end)
  end
end