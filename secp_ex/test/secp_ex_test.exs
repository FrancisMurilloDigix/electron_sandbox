defmodule SecpExTest do
  use ExUnit.Case
  doctest SecpEx

  test "greets the world" do
    assert SecpEx.hello() == :world
  end
end
