defmodule Scipio.Utils.PipelineTest do
  use ExUnit.Case
  alias Scipio.Utils .Pipeline

  # @tag :skip
  test "parse tasks" do
    # Map.equal?(%{a: 1, b: 2}, %{b: 2, a: 1})
    tasks = "add_1 > add_2 > add_3"
    assert Pipeline.parse(tasks) == %{
      add_1: :add_2,
      add_2: :add_3
    }

    tasks = "[add_6,add_8] > [add_9,add_10]"
    assert Pipeline.parse(tasks) == %{
      add_6: [:add_9,:add_10],
      add_8: [:add_9,:add_10]
    }
  end

  # @tag :skip
  test "parse pipelines" do
    pipelines = [
      "add_1 > add_2 > add_3",
      "[add_6, add_8] > [add_9, add_10]"
    ]
    assert Pipeline.parse(pipelines) == %{
      entry_: [:add_1, :add_6, :add_8],
      add_1: :add_2,
      add_2: :add_3,
      add_6: [:add_9,:add_10],
      add_8: [:add_9,:add_10]
    }

    pipelines = [
      "add_1 > add_2 > add_3",
      "[add_3, add_8] > [add_9, add_10]"
    ]
    assert Pipeline.parse(pipelines) == %{
      entry_: [:add_1, :add_8],
      add_1: :add_2,
      add_2: :add_3,
      add_3: [:add_9,:add_10],
      add_8: [:add_9,:add_10]
    }

    pipelines = [
      "add_1 > [add_2,add_3] > add_4",
      "add_3 > [add_4,add_5] > add_6",
      "add_6 > [add_7,add_8]",
      "[add_6,add_8] > [add_9,add_10]",
    ]
    assert Pipeline.parse(pipelines) == %{
      entry_: [:add_1],
      add_1: [:add_2, :add_3],
      add_2: :add_4,
      add_3: [:add_4, :add_5],
      add_4: :add_6,
      add_5: :add_6,
      add_6: [:add_9, :add_10, :add_7, :add_8],
      add_8: [:add_9, :add_10]
    }
  end

  test "parse pipeline config" do
    task_name = :arithmetic
    pipeline_config = Application.get_env(:scipio, task_name) |> Keyword.get(:pipeline)
    assert pipeline_config |> Pipeline.parse(:config) == ["add_1 > add_2 > add_3", "add_2 > add_4 > add_3"]
  end
end
