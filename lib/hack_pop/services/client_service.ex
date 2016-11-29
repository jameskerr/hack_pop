defmodule HackPop.Services.ClientService do

  alias HackPop.Schemas.Client
  alias HackPop.Repo

  def create(params \\ %{}) do
    %Client{}
    |> Client.changeset(params)
    |> Repo.insert
  end
end
