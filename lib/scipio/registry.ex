defmodule Scipio.Registry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :scheduler_registry)
  end

  def whereis_name(room_name) do
    GenServer.call(:scheduler_registry, {:whereis_name, room_name})
  end

  def register_name(room_name, pid) do
    GenServer.call(:scheduler_registry, {:register_name, room_name, pid})
  end

  def unregister_name(room_name) do
    GenServer.cast(:scheduler_registry, {:unregister_name, room_name})
  end

  def send(room_name, message) do
    case whereis_name(room_name) do
      nil -> {:badarg, {room_name, message}}
      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  # SERVER
  def init(_) do
    # use Map store pid %{"room_name" => pid}
    {:ok, Map.new}
  end

  def handle_call({:whereis_name, room_name}, _from, state) do
    {:reply, Map.get(state, room_name), state}
  end

  def handle_call({:register_name, room_name, pid}, _from, state) do
    case Map.get(state, room_name) do
      nil ->
        # 监控每个进程 -> handle_info
        Process.monitor(pid)
        {:reply, :yes, Map.put(state, room_name, pid)}
      _ ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_name, room_name}, state) do
    {:noreply, Map.delete(state, room_name)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    {:noreply, remove_pid(state, pid)}
  end

  def remove_pid(state, pid_to_remove) do
    remove = fn {_key, pid} -> pid != pid_to_remove end
    Enum.filter(state, remove) |> Enum.into(%{})
  end
end
