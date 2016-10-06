defmodule HackPop.Pusher do
  def push(story) do
    message = APNS.Message.new
      |> Map.put(:token, "227709926002e21fdd75d5786203741f62b74f79571806618562996d41292597")
      |> Map.put(:alert, "#{story.title}\nPoints: #{story.points}")
      |> Map.put(:badge, 0)
      |> Map.put(:extra, %{
        url: story.url,
        points: story.points
      })
    APNS.push(:dev_pool, message)
  end
end
