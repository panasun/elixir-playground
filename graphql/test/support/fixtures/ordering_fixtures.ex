defmodule Graphql.OrderingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Graphql.Ordering` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        customer_number: 42,
        items: %{},
        ordered_at: ~U[2023-05-28 04:11:00Z],
        state: "some state"
      })
      |> Graphql.Ordering.create_order()

    order
  end
end
