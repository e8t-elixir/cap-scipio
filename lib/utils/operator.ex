defmodule Scipio.Utils.Operator do
  def a > b when is_list(a) and is_list(b), do: [a | [b]]
  def a > b when is_list(a), do: a ++ [b | []]
  def a > b, do: [a | [b]]
end
