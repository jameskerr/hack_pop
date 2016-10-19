defmodule HackPop.StoryNotification do

  @derive [Poison.Encoder]
  defstruct [:title, :url, :points, :notification_id, :story_id]

  def cast(story, notification) do
    %HackPop.StoryNotification{
      title:           story.title,
      url:             story.url,
      points:          story.points,
      story_id:        story.id,
      notification_id: notification.id
    }
  end
end
