defmodule KeyValCluster.KeyVal do
  use GenServer
  require Logger

  def child_spec(key), do: %{id: key, start: {__MODULE__, :start_link, [key]}}

  def start_link(key) do
    GenServer.start_link(__MODULE__, key, name: via_tuple(key))
  end

  def create(key) do
    Horde.DynamicSupervisor.start_child(
      KeyValCluster.KeyValSupervisor,
      {KeyValCluster.KeyVal, key}
    )
  end

  def put(key, value) do
    GenServer.cast(via_tuple(key), {:put, value})
  end

  def get(key) do
    GenServer.call(via_tuple(key), {:get})
  end

  defp via_tuple(key) do
    {:via, Horde.Registry, {KeyValCluster.Registry, key}}
  end

  def init(key) do
    data = KeyValCluster.DB.fetch(:account, key)
    {:ok, {key, data || []}}
  end

  def handle_cast({:put, new_value}, {key, value}) do
    r_value = value ++ new_value
    KeyValCluster.DB.save(:account, key, r_value)
    {:noreply, {key, r_value}}
  end

  def handle_call({:get}, _from, state = {_, value}) do
    {:reply, value, state}
  end
end
