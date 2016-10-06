defmodule HackPop.Pusher do
  def push(story, client_id) do
    message = APNS.Message.new
      |> Map.put(:token, client_id)
      |> Map.put(:alert, "#{story.title}\nPoints: #{story.points}")
      |> Map.put(:badge, 0)
      |> Map.put(:extra, %{
        url: story.url,
        points: story.points
      })
    APNS.push(:dev_pool, message)
  end
end
