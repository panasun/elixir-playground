defmodule GenStateMachineTest do
  use ExUnit.Case
  doctest GenStateMachine

  test "greets the world" do
    assert GenStateMachine.hello() == :world
  end
end
