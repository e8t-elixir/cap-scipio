defmodule Scipio.Utils do

  require Logger
  
  def get_local_fun_name(env), do: env.function |> elem(0)

  def load_file(path, :pipeline) do
    case File.read(path) do
      {:ok, content} ->
        content
      {:error, reason} ->
        Logger.warn(reason)
    end
  end
end
