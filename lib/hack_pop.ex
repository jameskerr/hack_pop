require Logger

defmodule HackPop do
  def main(args) do
    options = parse_args(args)

    coord_task = Task.async(HackPop.Coordinator, :start, [options[:n]])
    do_requests(options[:n], options[:url])

    Task.await(coord_task, :infinity)
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [n: :integer, url: :string]
    )
    options
  end

  defp do_requests(n, url) do
    Enum.each(1..n, fn(i) ->
      spawn HackPop.Http, :request, [i, url]
    end)
  end
end
