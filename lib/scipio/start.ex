defmodule Scipio.Start do

  alias Scipio.TaskConfig
  alias Scipio.Queue.DynamicSupervisor, as: QueueSupervisor
  alias Scipio.Queue
  require Logger

  def run(task_names) when is_list(task_names) do
    for task_name <- task_names do
      run(task_name)
    end
  end

  @doc """
    name Scheduler-\#{pipeline_name}-\#{pipeline_uuid}
    name Queue-\#{pipeline_name}-\#{pipeline_uuid}
    name Task-\#{task_name}-\#{task_uuid}
  """
  def run(task_name) do
    # arithmetic
    case Application.get_env(:scipio, task_name) do
      nil -> Logger.warn("no such task config")
      config ->
        case TaskConfig.new(config) do
          {:error, reason} -> {:error, reason}
          task_config ->
            # task_config = TaskConfig.new(config)
            IO.puts(task_config |> inspect())
            if task_config.dry_run do
              # run_now: true, one_time: true
              IO.puts("Run in test mode")
            else
              QueueSupervisor.start_child({Queue, state: task_config, name: "Queue-#{task_name}-#{UUID.uuid4(:hex)}"})
            end
        end
    end
  end
end
