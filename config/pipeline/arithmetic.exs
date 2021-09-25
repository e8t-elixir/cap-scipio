use Mix.Config

config :scipio, :arithmetic,
  executors: %{
    add_1: "Add.add_1",
    add_2: "Add.add_2",
    add_3: "Add.add_3",
    add_4: "Add.add_4"
  },
  pipeline: ~s(
    add_1 > add_2 > add_3
    add_2 > add_4 > add_3
  ),
  pipeline_name: :arithmetic,
  dry_run: false,
  run_now: true,
  one_time: true,
  long_time: {:crontab, ""}
  # long_time: {:crontab, [""]}
  # long_time: {:internal, [""]}
  # long_time: {:generator, function}
