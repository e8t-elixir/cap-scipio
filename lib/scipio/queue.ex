defmodule Scipio.Queue do
  @moduledoc """
    The `Scipio.Queue` server implementation

    单点服务
  """

  use GenServer
  use Timex
  require Logger

  alias Scipio.Scheduler.DynamicSupervisor, as: SchedulerSupervisor
  alias Scipio.Scheduler
  alias Timex.Duration

  ##############################################################################

  @doc "Starts the `Scipio.Queue` server up"
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def start_link(_opts, [state: state, name: name]) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  def init(%{one_time: true, first_run_time: first_run_time} = state) do

  end

  # def init(%{one_time: true, run_after: run_after} = state) do
  #   # run_after -> first_run_time in task_config.ex
  # end

  @doc """
  run_now -> first_run_time
  """
  # def init(%{long_time: long_time, run_now: true} = state) do
  #   # state = parse(state, :long_time)
  # end

  def init(%{long_time: long_time, first_run_time: first_run_time} = state) do

  end

  # def init(%{long_time: true, run_now: false, run_after: run_after} = state) do
  #   # run_after -> first_run_time in task_config.ex
  # end

  ##############################################################################

  # @spec state() :: any()
  # def state(), do: handle_call(__MODULE__, :state)

  # @spec state!(new_state) :: any()
  # def state!(), do: handle_cast(__MODULE__, {:state!, new_state})

  def start(:scheduler, task_config) do
    # start scheduler
    SchedulerSupervisor.start_child({Scheduler, state: task_config, name: "Scheduler-#{task_config.pipeline_name}-#{UUID.uuid4(:hex)}"})
  end

  @doc """
  waiting for
    start new task
  """
  def loop(next_run_time, state) do
    # receive do
    # after cal_time_gap(next_run_time) ->
    #   loop(next_run_time, state)
    # end
  end

  def gen_after_time(first_run_time) do
    with now <- Timex.now("Asia/Shanghai") |> Timex.to_unix() |> Duration.from_seconds() do
      diff = Duration.diff(first_run_time, now, :milliseconds)
      if diff > 0, do: diff, else: 0
    end
  end

  def gen_after_time(first_run_time, {:crontab, crontab}) do
    import Crontab.CronExpression
    with {:ok, cron} <- Crontab.CronExpression.Parser.parse(crontab),
         {:ok, next} <- Crontab.Scheduler.get_next_run_date(cron, first_run_time),
         {:ok, next_dt} <- DateTime.from_naive(next, "Asia/Shanghai", Tzdata.TimeZoneDatabase),
         next_run_time <- next_dt |> Timex.to_unix() |> Duration.from_seconds() do
      diff = Duration.diff(next_run_time, first_run_time, :milliseconds)
    end
  end

  def gen_after_time(_first_run_time, {:internal, internal}), do: internal

  def gen_after_time(_first_run_time, {:generator, generator}) do
  end

  def parse_time(first_run_time), do: Timex.parse(first_run_time, "%F %T", :strftime)

  ##############################################################################

  # @doc false
  # def handle_call(:state, _from, state), do: {:reply, state, state}

  # @doc false
  # def handle_cast({:state!, new_state}, state), do: {:noreply, {state, new_state}}

  # @doc false
  # def handle_info({:DOWN, _ref, :process, _pid, :normal}, state), do: {:noreply, state}
end
