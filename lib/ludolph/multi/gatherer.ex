defmodule Ludolph.Multi.Gatherer do
  use GenServer

  alias Ludolph.Multi

  @me Gatherer

  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: @me)
  end

  def done() do
    GenServer.cast(@me, :done)
  end

  def result(index) do
    GenServer.cast(@me, {:result, index})
  end

  def init(worker_count) do
    Process.send_after(self(), {:kickoff, worker_count}, 0)
    {:ok, worker_count}
  end

  def handle_info({:kickoff, worker_count}, _state) do
    1..worker_count
    |> Enum.each(fn _ -> Multi.WorkerSupervisor.add_worker() end)

    { :noreply, worker_count }
  end

  def handle_cast(:done, _worker_count = 1) do
    report_results()
  end

  def handle_cast(:done, work_count) do
    { :noreply, work_count - 1}
  end

  def handle_cast({:result, index}, work_count) do
    Multi.Results.add(index)
    { :noreply, work_count }
  end

  defp report_results() do
    IO.puts("Results: \n")
    Multi.Results.get()
    pid = :global.whereis_name(:cli)

    send(pid, {:ok, 0})
  end
end
