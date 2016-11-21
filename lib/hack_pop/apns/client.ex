defmodule HackPop.APNS.Client do
  def start do
    APNS.start nil, nil
  end

  def push(message, sync: true) do
    APNS.push_sync(pool, message)
  end

  def push(message, sync: false) do
    APNS.push(pool, message)
  end

  defp pool do
    Application.get_env(:hack_pop, :apns_pool)
  end
end
