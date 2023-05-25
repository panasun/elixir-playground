defmodule Graphql.Repo.Migrations.AddItemsTable do
  use Ecto.Migration

  def change do
    create table("items") do
      add :added_on, :date
      add :description, :string
      add :name, :string
      add :price, :decimal

      timestamps()
    end
  end
end
