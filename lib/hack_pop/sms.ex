defmodule HackPop.Sms do
  @sid "ACa8970b1ca70f33b784ac7669d3f47c9c"
  @auth_token "1528c0fa7b7677aacf792896e0f509fd"
  @url "https://#{@sid}:#{@auth_token}@api.twilio.com/2010-04-01/Accounts/#{@sid}/Messages.json"
  @from "+16672072592"


  def send_story(to, story) do
    body = "HackPop: #{story.title} - #{story.score}\n#{story.url}"
    send_sms(to, body)
  end

  defp send_sms(to, body) do
    params   = [{:To, to}, {:From, @from}, {:Body, body}]
    HTTPoison.post!(@url, {:form, params})
  end
end