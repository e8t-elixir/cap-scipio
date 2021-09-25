defmodule Scipio.Utils.Helper do

  defmacro add(x, y) do
    for i <- x..y do
      quote do
        def unquote(:"add_#{i}")(data) do
          IO.inspect({__MODULE__, __ENV__ |> Scipio.Utils.get_local_fun_name})
          data + unquote(i)
        end
      end
    end
  end

  defmacro add(x) when is_number(x) do
    quote do
      def unquote(:"add_#{x}")(data) do
        data + unquote(x)
      end
    end
  end
end
