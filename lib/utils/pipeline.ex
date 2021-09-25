defmodule Scipio.Utils.Pipeline do

  require Logger

  def is_valid(pipelines) when is_list(pipelines), do: pipelines
  def is_valid(tasks), do: tasks

  def parse(pipeline, :config) do
    String.trim(pipeline)
    |> String.split("\n")
    |> Enum.map(fn item -> String.trim(item) end)
  end

  @doc """
    pipelines
    [
      add_1 > add_2 > add_3,
      add_1 > add_2 > add_3
    ]

    tasks add_1 > add_2 > add_3
  """
  def parse(pipelines) when is_list(pipelines) do
    tasks_map = pipelines
    |> Enum.map(fn pipeline -> parse(pipeline) end)
    |> Enum.reduce(%{}, fn acc, item ->
      merge_pipes(acc, item)
    end)
    entry_tasks = Enum.filter(Map.keys(tasks_map), fn item -> item not in List.flatten(Map.values(tasks_map)) end)
    tasks_map |> Map.put(:entry_, entry_tasks)
  end

  def parse(tasks) do
    import Scipio.Utils.Operator
    import Kernel, except: [>: 2, <: 2]
    tasks
    |> Code.string_to_quoted()
    |> parse_quoted_form()
  end

  @doc """
  add_1 > [add_2,add_3] > [add_4,add_5] > add_6

  to

  %{
    _entry: :add_1,
    add_1: [:add_2, :add_3],
    add_2: [:add_4, :add_5],
    add_3: [:add_4, :add_5],
    add_4: :add_6,
    add_5: :add_6
  }
  """
  def parse_quoted_form(quoted_result) do
    import Scipio.Utils.Operator
    import Kernel, except: [>: 2, <: 2]

    case quoted_result do
      {:ok, quoted_form} ->
        operator_list = quoted_form |> lookup_ast() |> List.flatten()
        params = Enum.zip(operator_list, operator_list)
        { eval_result, _} = quoted_form
          |> Code.eval_quoted(params, __ENV__)
        eval_result
        |> Enum.chunk_every(
          2, 1, :discard
        )
        |> Enum.map(fn [first, last] ->
          cond do
            is_list(first) ->
              for i <- first, do:  {i, last}
            true ->
              {first, last}
          end
        end)
        |> List.flatten()
        |> Map.new()
      {:error, {_line, error, _token}} -> Logger.error(error |> inspect())
    end
  end

  def lookup_ast({node, _, next}) when is_nil(next), do: node

  def lookup_ast({_, _, next}), do: lookup_ast(next)

  def lookup_ast(next) when is_list(next) do
    next |> Enum.map(fn n -> lookup_ast(n) end)
  end

  def merge_pipes(pipe1, pipe2) when is_map(pipe1) and is_map(pipe2) do
    # IO.inspect([pipe1, pipe2])
    Map.merge(pipe1, pipe2, fn _k, v1, v2 ->
      cond do
        is_list(v1) and is_list(v2) -> v1 ++ v2
        not is_list(v1) and not is_list(v2) -> [v1] ++ [v2]
        is_list(v1) and not is_list(v2) -> v1 ++ [v2]
        not is_list(v1) and is_list(v2) -> [v1] ++ v2
      end  |> Enum.uniq()
    end)
  end
  def load_file(path) do
    import Mix.Config
    import_config(path)
  end
end
