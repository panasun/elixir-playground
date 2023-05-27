defmodule GraphqlWeb.Schema do
  use Absinthe.Schema

  alias Graphql.{Menu, Repo}
  alias GraphqlWeb.Resolvers

  import Ecto.Query

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
      arg(:filter, :menu_item_filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  scalar :date do
    parse(fn input ->
      case Date.from_iso8601(input.value) do
        {:ok, date} -> {:ok, date}
        _ -> :error
      end
    end)

    serialize(fn date ->
      Date.to_iso8601(date)
    end)
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
    field :added_on, :date
  end

  @desc "Filtering options for the menu item list"
  input_object :menu_item_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a category name"
    field :category, :string

    @desc "Matching a tag"
    field :tag, :string

    @desc "Priced above a value"
    field :priced_above, :float

    @desc "Priced below a value"
    field :priced_below, :float

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end
end
