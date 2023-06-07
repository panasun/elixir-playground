defmodule KeyValCluster.DB do
  use GenServer

  def start_link(_) do
    children = Enum.map([:account, :order], &worker_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def init(args) do
    {:ok, args}
  end

  defp worker_spec(worker_id) do
    Supervisor.child_spec({KeyValCluster.DBWorker, {worker_id}}, id: worker_id)
  end

  def save(worker_id, key, value) do
    KeyValCluster.DBWorker.save(worker_id, key, value)
  end

  def fetch(worker_id, key) do
    KeyValCluster.DBWorker.fetch(worker_id, key)
  end
end

defmodule KeyValCluster.DBWorker do
  use GenServer

  def start_link({worker_id}) do
    GenServer.start_link(__MODULE__, worker_id, name: via_tuple(worker_id))
  end

  defp via_tuple(worker_id) do
    # KeyValCluster.Registry.via_tuple({__MODULE__, worker_id})
    {:via, Horde.Registry, {KeyValCluster.Registry, worker_id}}
  end

  def init(worker_id) do
    # {:ok, db} = CubDB.start_link(data_dir: "cubdb/" <> Atom.to_string(worker_id))
    # IO.puts(db)
    # {:ok, db}
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
