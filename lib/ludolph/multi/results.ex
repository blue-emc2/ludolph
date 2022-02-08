defmodule Ludolph.Multi.Results do
  use GenServer

  @me __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: @me)
  end

  @impl true
  def init(:no_args) do
    {:ok, []}
  end

  def add(index) do
    GenServer.cast(@me, {:add, index})
  end

  def get() do
    GenServer.call(@me, :get)
  end

  @impl true
  def handle_cast({:add, index}, results) do
    results = [index | results]
    {:noreply, results}
  end

  @impl true
  def handle_call(:get, _from, results) do
    {:reply, results, results}
  end
end
