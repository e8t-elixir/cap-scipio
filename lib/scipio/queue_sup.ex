defmodule Scipio.Queue.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(spec) do
    # %{
    #   Scipio.Queue,
    #   [
    #     state: %{},
    #     name: "Queue-#{pipeline_name}-#{pipeline_uuid}"
    #   ]
    # }
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(init_arg) do
    # DynamicSupervisor.init(strategy: :one_for_one)
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [init_arg]
    )
  end

  def child_spec(arg) do
    # supervisor in application call child_spec
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [arg]},
      type: :supervisor
    }
  end
end
