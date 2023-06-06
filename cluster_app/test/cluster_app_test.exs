defmodule ClusterAppTest do
  use ExUnit.Case
  doctest ClusterApp

  test "greets the world" do
    assert ClusterApp.hello() == :world
  end
end
