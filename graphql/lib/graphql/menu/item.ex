defmodule Graphql.Menu.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Graphql.Menu.Item

  schema "items" do
    field :added_on, :date
    field :description, :string
    field :name, :string
    field :price, :decimal

    # belongs_to :category, Graphql.Menu.Category

    # many_to_many :tags, Graphql.Menu.ItemTag, join_through: "items_taggings"
    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :added_on])
    |> validate_required([:name, :price])

    # |> foreign_key_constraint(:category)
  end
end
