defmodule HackPopTest.SmsTest do
  use ExUnit.Case, async: true

  test "send_story" do
    story = %{title: "Cool story bro", score: 455, url: "http://jameskerr.info"}
    HackPop.Sms.send_story("7143096756", story)
  end
end