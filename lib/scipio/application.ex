defmodule Scipio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Scipio.Worker.start_link(arg)
      # {Scipio.Worker, arg}
      # {Scipio.Scheduler, []},
      # {Scipio.Executor, []},
      {Scipio.Scheduler.DynamicSupervisor, []},
      {Scipio.Queue.DynamicSupervisor, []},

      {Plug.Cowboy, scheme: :http, plug: Scipio.Server.Router, options: [port: 4001]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scipio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
