defmodule HackPop.Queries.TrendingStories do
  import Ecto.Query, only: [from: 2]

  def get do
    HackPop.Repo.all query
  end

  defp query do
    from s in HackPop.Schemas.Story,
      where: s.trending == true,
      order_by: [desc: :points]
  end
end
