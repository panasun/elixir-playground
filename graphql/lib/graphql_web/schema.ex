defmodule GraphqlWeb.Schema do
  use Absinthe.Schema

  alias Graphql.{Menu, Repo}
  alias GraphqlWeb.Resolvers

  import Ecto.Query

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  query do
    field :menu_item, :menu_item do
      resolve(fn _, _, _ ->
        {:ok, %{id: 1, name: "Bin", description: "Hello"}}
      end)
    end

    # field :menu_items, list_of(:menu_item) do
    #   arg :matching, :string
    #   resolve(fn _, _, _ ->
    #     IO.inspect(Menu.Item)
    #     {:ok, Repo.all(Menu.Item)}
    #   end)
    # end

    # field :menu_items, list_of(:menu_item) do
    #   arg(:name, :string)

    #   resolve(fn
    #     _, %{name: name}, _ when is_binary(name) ->
    #       query = from m in Menu.Item, where: like(m.name, ^"%#{name}%")
    #       {:ok, Repo.all(query)}

    #     _, _, _ ->
    #       {:ok, Repo.all(Menu.Item)}
    #   end)
    # end

    field :menu_items, list_of(:menu_item) do
      arg(:name, :string)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end
end
