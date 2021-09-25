defmodule Scipio.TaskConfig do

  @moduledoc """

  first_run_time <- Timex.parse(first_run_time, "%F %T", :strftime)

  Timex.now("Asia/Shanghai") |> Timex.to_unix |> Duration.from_seconds()

  run_after -> first_run_time
  run_now -> first_run_time

  internal -> milliseconds

  """
  alias Scipio.Utils.Pipeline

  # @enforce_keys [:pipeline, :executors]

  defstruct [
    # :task_map,
    # :last_run_time,
    # :last_run_uid,
    # :start_time,  # next_run_time
    # :scheduler_pid,
    executors: [],
    pipeline: %{},
    pipeline_name: nil,
    dry_run: false,
    run_now: false,
    one_time: false,
    long_time: {},
    run_after: 0,  # second
    first_run_time: "",  # parse to time by Timex "2019-09-19 01:09:01"
  ]

  # validate config
  def validate(config) do
    {:ok, config}
  end

  # create new TaskConfig from config
  def new(config) do
    case validate(config) do
      {:ok, config} ->
        pipeline = config |> Keyword.get(:pipeline) |> Pipeline.parse(:config) |> Pipeline.parse()
        struct(%Scipio.TaskConfig{}, config)
        |> Map.put(:pipeline, pipeline)
      {:error, reason} -> {:error, reason}
    end
  end
end
