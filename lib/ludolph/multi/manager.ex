defmodule Ludolph.Multi.Manager do
  use GenServer

  @me Manager

  # Client

  def start_link(args) do
    IO.inspect("manager start_link")
    IO.inspect(args)
    GenServer.start_link(__MODULE__, args, name: @me)
  end

  def next_numbers(length) do
    IO.puts("next_numbers 1")
    IO.inspect("length=#{length}")
    GenServer.call(@me, {:next_numbers, length})
  end

  @impl true
  def init([pattern: pattern, path: path]) do
    {:ok, file} = File.open(path, [:read])

    {:ok, {file, pattern}}
  end

  @impl true
  def handle_call({:next_numbers, length}, _from, {file, pattern}) do
    IO.puts("next_numbers 2 read begin")

    n = IO.read(file, length)

    {:reply, {n, pattern}, {file, pattern}}
  end
end
