defmodule GraphqlWeb.Schema do
  use Absinthe.Schema

  alias Graphql.{Menu, Repo}

  query do
    field :menu_item, :menu_item do
      resolve(fn _, _, _ ->
        {:ok, %{id: 1, name: "Bin", description: "Hello"}}
      end)
    end

    field :menu_items, list_of(:menu_item) do
      resolve(fn _, _, _ ->
        IO.inspect(Menu.Item)
        {:ok, Repo.all(Menu.Item)}
      end)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end
end
