defmodule HackPop.Views.NotificationView do
  @derive [Poison.Encoder]
  defstruct [:title, :url, :comments_url, :points, :notification_id, :story_id]

  def cast([]), do: []

  def cast(notification = %{}) do
    %__MODULE__{
      title:           notification.story.title,
      url:             notification.story.url,
      comments_url:    notification.story.comments_url,
      points:          notification.story.points,
      story_id:        notification.story.id,
      notification_id: notification.id
    }
  end

  def cast(list) do
    Enum.map list, &cast/1
  end
end
