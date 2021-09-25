defmodule Scipio.Utils.Executor do
  require Logger

  defmacro use(path) do
    for module <- get_executors(path) do
      #   for {name, arg_count} <- module.__info__(:functions) do
      #     fn_args = create_args(module, arg_count)
      #     quote do
      #       defdelegate unquote(name)(unquote_splicing(fn_args)), to: unquote(module)
      #     end
      #   end
    end
  end

  def create_args(_, 0), do: []

  # fn_mdl fn 所在 module; arg_cnt fn 参数个数
  def create_args(fn_mdl, arg_cnt), do: Enum.map(1..arg_cnt, &Macro.var(:"arg#{&1}", fn_mdl))

  def get_executors(path) do
    try do
      File.ls!(path)
      |> Enum.map(&Path.join(path, &1))
      |> Enum.flat_map(
        &(Code.require_file(&1)
          |> Enum.map(fn {first, _} -> first end))
      )
    rescue
      e in [Protocol.UndefinedError, CompileError] ->
        Logger.warn(e |> inspect())
        []
    end

    # |> Enum.flat_map(
    #   &(Code.require_file(&1) |> Enum.map(
    #     fn {first, _} -> first end
    #   ))
    # )
  end
end
