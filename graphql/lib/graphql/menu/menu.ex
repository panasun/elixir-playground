defmodule Graphql.Menu do
  import Ecto.Query
  alias Graphql.{Menu, Repo}

  # def list_items(%{name: name}) when is_binary(name) do
  #   Menu.Item
  #   |> where([m], ilike(m.name, ^"%#{name}%"))
  #   |> Repo.all
  # end

  def list_items(args) do
    args
    |> IO.inspect()
    |> Enum.reduce(Menu.Item, fn
      {_, nil}, query ->
        query

      {:order, order}, query ->
        # from q in query, order_by: {^order, :name}
        query |> order_by({^order, :name})

      {:filter, filter}, query ->
        query |> filter_with(filter)
    end)
    |> IO.inspect()
    |> Repo.all()
  end

  def list_items(_) do
    Repo.all(Menu.Item)
  end

  defp filter_with(query, filter) do
    Enum.reduce(
      filter,
      query,
      fn
        {:name, name}, query ->
          from q in query, where: ilike(q.name, ^"%#{name}%")

        {:priced_above, price}, query ->
          from q in query, where: q.price >= ^price

        {:priced_below, price}, query ->
          from q in query, where: q.price <= ^price

        {:added_after, date}, query ->
          from q in query, where: q.added_on >= ^date

        {:added_before, date}, query ->
          from q in query, where: q.added_on <= ^date

        {:category, category_name}, query ->
          from q in query,
            join: c in assoc(q, :category),
            where: ilike(c.name, ^"%#{category_name}%")

        {:tag, tag_name}, query ->
          from q in query,
            join: t in assoc(q, :tags),
            where: ilike(t.name, ^"%#{tag_name}%")
      end
    )
  end
end
