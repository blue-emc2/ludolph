defmodule Ludolph.Multi.Manager do
  use GenServer, restart: :temporary

  @me Manager

  # Client

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @me)
  end

  def next_numbers(length) do
    GenServer.call(@me, {:next_numbers, length})
  end

  @impl true
  def init(pattern: pattern, path: path) do
    file = File.open!(path, [:read])
    {:ok, {file, pattern}}
  end

  @impl true
  def handle_call({:next_numbers, length}, _from, {file, pattern}) do
    n = IO.read(file, length)

    {:reply, {n, pattern}, {file, pattern}}
  end
end
