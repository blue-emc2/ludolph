defmodule Ludolph.Multi.Application do
  def start(_type, args) do
    children = [
      Ludolph.Multi.Results,
      { Ludolph.Multi.Manager, args },
      Ludolph.Multi.WorkerSupervisor,
      { Ludolph.Multi.Gatherer, 1 }
    ]

    opts = [strategy: :one_for_all, name: Ludolph.Multi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
