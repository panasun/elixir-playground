defmodule Graphql.Repo.Migrations.UpdateItems2 do
  use Ecto.Migration

  def change do
    create index(:items, [:category_id])
  end
end
