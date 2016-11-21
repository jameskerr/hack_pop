defmodule HackPop.ErrorReporting do
  def start_link do
    Bugsnag.start nil, nil
  end
end
