defmodule HackPop.Errors.Reporting do
  def start do
    Bugsnag.start nil, nil
  end

  def report(exception, options) do
    Bugsnag.report exception, options
  end
end
