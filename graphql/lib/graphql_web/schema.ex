defmodule GraphqlWeb.Schema do
  use Absinthe.Schema

  query do
    field :menu_item, :menu_item do
      resolve(fn _, _, _ ->
        {:ok[id: 1, name: "Bin", description: "Hello"]}
      end)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end
end
