defmodule HackPop.Queries.RecentUnreadNotifications do
  import Ecto.Query, only: [from: 2]

  def get(client) do
    client
    |> query
    |> HackPop.Repo.all
  end

  defp query(client) do
    from n in HackPop.Schemas.Notification,
      where:    n.client_id   == ^client.id
        and     n.read        == false
        and     n.inserted_at >= ago(5, "day"),
      limit:    15,
      order_by: [desc: :inserted_at],
      preload:  [:story]
  end
end
