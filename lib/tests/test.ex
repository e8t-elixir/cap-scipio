defmodule Scipio.Tests.Test do
  @moduledoc """
    The `` server implementation
  """

  use GenServer

  require Logger

  ##############################################################################

  @doc "Starts the `` server up"
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(args \\ 0) do
    case args do
      [] -> {:ok, 0}
      _ -> {:ok, args}
    end
  end

  ##############################################################################

  # @spec state() :: any()
  # def state(), do: handle_call(__MODULE__, :state)

  # @spec state!(new_state) :: any()
  # def state!(), do: handle_cast(__MODULE__, {:state!, new_state})

  def add(value) do
    GenServer.call(__MODULE__, {:add, value})
  end

  def sub(value) do
    GenServer.call(__MODULE__, {:sub, value})
  end

  ##############################################################################

  @doc false
  def handle_call(:state, _from, state), do: {:reply, state, state}

  def handle_call({:add, value}, _from, state) do
    {:reply, state+value, state+value}
  end

  def handle_call({:sub, value}, _from, state) do
    :timer.sleep(15 * 1000)
    {:reply, state-value, state-value}
  end

  @doc false
  def handle_cast({:state!, new_state}, state), do: {:noreply, {state, new_state}}

  @doc false
  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state), do: {:noreply, state}
end
