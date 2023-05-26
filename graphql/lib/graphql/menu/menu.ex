defmodule Graphql.Menu do
  import Ecto.Query
  alias Graphql.{Menu, Repo}

  # def list_items(%{name: name}) when is_binary(name) do
  #   Menu.Item
  #   |> where([m], ilike(m.name, ^"%#{name}%"))
  #   |> Repo.all
  # end

  def list_items(filters) do
    filters
    |> IO.inspect()
    |> Enum.reduce(Menu.Item, fn
      {_, nil}, query ->
        query

      {:order, order}, query ->
        from q in query, order_by: {^order, :name}

      {:name, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}%")
    end)
    |> IO.inspect()
    |> Repo.all()
  end

  def list_items(_) do
    Repo.all(Menu.Item)
  end
end
