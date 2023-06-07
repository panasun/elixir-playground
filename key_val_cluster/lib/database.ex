defmodule KeyValCluster.DB do
  use GenServer

  def child_spec(worker_id), do: %{id: worker_id, start: {__MODULE__, :start_link, [worker_id]}}

  def start_link(worker_id) do
    GenServer.start_link(__MODULE__, worker_id, name: via_tuple(worker_id))
  end

  def create() do
    Horde.DynamicSupervisor.start_child(
      KeyValCluster.DBSupervisor,
      {KeyValCluster.DB, :account}
    )

    Horde.DynamicSupervisor.start_child(
      KeyValCluster.DBSupervisor,
      {KeyValCluster.DB, :order}
    )
  end

  defp via_tuple(worker_id) do
    {:via, Horde.Registry, {KeyValCluster.Registry, worker_id}}
  end

  def init(worker_id) do
    CubDB.start_link(data_dir: "cubdb/" <> Atom.to_string(worker_id))
  end

  def save(worker_id, key, value) do
    GenServer.cast(via_tuple(worker_id), {:save, key, value})
  end

  def fetch(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:fetch, key})
  end

  def handle_call({:fetch, key}, _, db) do
    data = CubDB.get(db, key)
    {:reply, data, db}
  end

  def handle_cast({:save, key, value}, db) do
    CubDB.put(db, key, value)
    {:noreply, db}
  end
end
