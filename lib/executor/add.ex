defmodule Scipio.Executor.Add do

  alias Scipio.Utils.Helper
  require Helper
  Helper.add(3, 6)

  def add_1(x), do: x + 1

  def add_2(x), do: x + 2

  defmacro __using__(_opt) do
    quote do
      def add_1(x), do: x + 1
      def add_2(x), do: x + 2
    end
  end
end
