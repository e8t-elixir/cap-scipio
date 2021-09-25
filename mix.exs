defmodule Scipio.MixProject do
  use Mix.Project

  def project do
    [
      app: :scipio,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # applications: [:crontab],
      # applications: [:timex],
      # 取消注释导致 ranch_server 进程未启动的错误
      # extra_applications: [:logger, :plug_cowboy],
      extra_applications: [:logger, :crypto],
      mod: {Scipio.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:elixir_uuid, "~> 1.2"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:timex, "~> 3.5"},
      {:crontab, "~> 1.1"}
    ]
  end
end
