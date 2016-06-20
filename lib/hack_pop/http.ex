require Logger

defmodule HackPop.Http do
  def request(id, url) do
    try do
      HTTPoison.get(url) |> handle_response(id)
    rescue
      error in HTTPoison.HTTPError ->
        Logger.info "#{id}: error (#{inspect error.message})"
    after
      send HackPop.Coordinator, {:finished, id}
    end
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}, _) do
    stories = HackPop.Parser.find_stories(body)
    Enum.each(stories, fn({title, score}) -> Logger.info("#{score} : #{title}") end)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code}}, id) do
    Logger.info "#{id} error (#{status_code})"
  end
end
