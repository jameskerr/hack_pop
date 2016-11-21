defmodule HackPop.Query.TrendingStories do
  import Ecto.Query, only: [from: 2]

  def get do
    HackPop.Repo.all query
  end

  defp query do
    from s in HackPop.Schema.Story,
      where: s.trending == true,
      order_by: [desc: :points]
  end
end
