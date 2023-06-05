defmodule KeyValTest do
  use ExUnit.Case
  # doctest KeyVal

  # test "greets the world" do
  #   assert KeyVal.hello() == :world
  # end

  test "KeyVal" do
    KeyVal.System.start()
    pid1 = KeyVal.Manager.create_store("store1")
    KeyVal.Server.put(pid1, "key", "value")

    IO.inspect(KeyVal.Server.get(pid1, "key"))
  end
end
