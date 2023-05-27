defmodule Graphql.Menu.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Graphql.Menu.Category

  schema "categories" do
    field :description, :string
    field :name, :string

    has_many :items, Graphql.Menu.Item

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:description, :name])
    |> validate_required([:name])
  end
end
