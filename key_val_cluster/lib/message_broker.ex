defmodule Anyrare.MessageBroker do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: via_tuple())
  end

  def via_tuple() do
    {:via Horde.Registry, {Anyrare.Registry, Anyrare.MessageBroker}}
  end

  def total_worker() do
    10
  end
end
