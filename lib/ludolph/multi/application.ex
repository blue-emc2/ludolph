defmodule Ludolph.Multi.Application do
  use Application

  @impl true
  def start(_type, args) do
    children = [
      # Starts a worker by calling: Multi.Worker.start_link(arg)
      # {Multi.Worker, arg}
      Ludolph.Multi.Results,
      { Ludolph.Multi.Manager, args },
      Ludolph.Multi.WorkerSupervisor,
      { Ludolph.Multi.Gatherer, 1 }
    ]

    # ret = Ludolph.Multi.Manager.start_link([path, pattern])
    # ret = Ludolph.Multi.PISearcher.start(path, pattern)

    opts = [strategy: :one_for_all, name: Ludolph.Multi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
