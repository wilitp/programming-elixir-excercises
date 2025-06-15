defmodule Account.Application do

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      { Account.Server, 0}
    ]

    opts = [strategy: :one_for_one, name: Account.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
