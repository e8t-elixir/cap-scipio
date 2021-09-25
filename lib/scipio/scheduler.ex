defmodule Scipio.Scheduler do
  use GenServer
  # alias

  def start_link(_opts, [state: state, name: name]) do
    # opts [strategy: :one_for_one, name: Scipio.Scheduler.DynamicSupervisor]
    # arg [state: state, name: name]
    GenServer.start_link(__MODULE__, [state: state, name: via_tuple(name)])
  end

  def child_spec([state: _state, name: name] = arg) do
    %{
      id: {__MODULE__, name},
      start: {__MODULE__, :start_link, [arg]}
    }
  end

  @impl true
  def init(state) do
    # call executor

    {:ok, state}
  end

  def handle_cast(action \\ {:next, nil}, state)

  @impl true
  def handle_cast({:next, req}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_cast({:something, 1}, state) do
    IO.puts "This executes first"
    {:stop, "This is my reason for stopping", state}
  end

  @impl true
  def terminate(reason, state) do
    IO.puts "Then this executes"
  end

  # @impl true
  # def handle_cast({:start, pipline}, state) do
  # end

  defp run() do
    # Task.start()
  end

  defp via_tuple(scheduler_name) do
    {:via, Scipio.Registry, {:scheduler, scheduler_name}}
  end
end
