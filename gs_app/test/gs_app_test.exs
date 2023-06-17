defmodule GsAppTest do
  use ExUnit.Case
  doctest GsApp

  test "greets the world" do
    assert GsApp.hello() == :world
  end
end
