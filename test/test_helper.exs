Ecto.Adapters.SQL.Sandbox.mode(HackPop.Repo, :manual)

# Do this so that when the Pinger automatically starts up, we
# can have a connection to the database. This connection is then
# shared with all other sub processes. I can't have any async tests
# though with this setup.
:ok = Ecto.Adapters.SQL.Sandbox.checkout(HackPop.Repo)
Ecto.Adapters.SQL.Sandbox.mode(HackPop.Repo, {:shared, self()})

ExUnit.start()

