defmodule Todolist do
  @moduledoc """
  Documentation for `Todolist`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Todolist.hello()
      :world

  """
  def hello(name) do
    "Hello " <> name
  end

  def hello(name, age) do
    "My name is 4 " <> name <> ", age " <> Integer.to_string(age)
  end

  @spec add_task([number], number) :: [number]
  def add_task(tasks, title) do
    tasks ++ [title]
  end

  def c_task, do: add_task([], 4)

  def add_task_agent(agent_id, title) do
    new_value = Agent.get(agent_id, fn tasks -> tasks end) ++ [title]
    Agent.update(agent_id, fn _tasks -> new_value end)
    new_value
    # Agent.get_and_update(agent_id, fn tasks -> tasks ++ [title] end)
  end

  def add_task_ets(table, data) do
    :ets.insert(table, data)
  end

  def init do
    :mnesia.create_schema([node()])
    :mnesia.start()
    :mnesia_rocksdb.register()

    :mnesia_schema.add_backend_type(:rocksdb_copies, :mnesia_rocksdb)

    :mnesia.create_table(:Person,
      # in mix.exs :included_applications [:mnesia], disc_copies will be
      # work with iex --name n1@nodebin.com -S mix
      # disc_copies: [node()],
      type: :set,
      rocksdb_copies: [node()],
      attributes: [:id, :name, :job],
      user_properties: [
        rocksdb_opts: [{:max_open_files, 1024}]
      ]
    )

    :mnesia.wait_for_tables([:Person], 1000)
  end

  def seed do
    :mnesia.dirty_write({:Person, 1, "Bin", "Programmer"})
    :mnesia.dirty_write({:Person, 2, "Jam", "Sale"})
    :mnesia.dirty_write({:Person, 2, "Looknut", "Dentist"})
  end

  def get_persons do
    :mnesia.table_info(:Person, :attributes)
    :mnesia.dirty_all_keys(:Person)
  end

  def get_persons_detail do
    :mnesia.dirty_match_object({:Person, :_, :_, :_})
  end

  def get_person_count do
    :mnesia.table_info(:Person, :size)
  end

  def add_persons(id, name, job) do
    :mnesia.dirty_write({:Person, id, name, job})
  end
end
