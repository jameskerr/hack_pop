defmodule HackPop.APNS.Message do
  def from_notification(notification) do
    APNS.Message.new
    |> Map.put(:token, notification.client_id)
    |> Map.put(:alert, notification.story.title)
    |> Map.put(:badge, 0)
    |> Map.put(:extra, %{
      url: notification.story.url,
      id:  notification.id,
      comments_url: notification.story.comments_url
      })
  end
end
