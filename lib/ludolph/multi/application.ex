defmodule Ludolph.Multi.Application do

  @jobs 5

  def start(_type, args) do
    {jobs, args} = Keyword.pop(args, :jobs, @jobs)

    children = [
      Ludolph.Multi.Results,
      {Ludolph.Multi.Manager, args},
      Ludolph.Multi.WorkerSupervisor,
      {Ludolph.Multi.Gatherer, jobs}
    ]

    opts = [strategy: :one_for_all, name: Ludolph.Multi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
