defmodule ScipioTest do
  use ExUnit.Case
  doctest Scipio

  test "greets the world" do
    assert Scipio.hello() == :world
  end
end
