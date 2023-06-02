defmodule Graphql.Repo.Migrations.UpdateItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :category_id, references(:categories, on_delete: :nothing)
    end
  end
end
