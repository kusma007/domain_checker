defmodule CheckerTest do
  use ExUnit.Case
  doctest Checker

  test "greets the world" do
    assert Checker.hello() == :world
  end
end
