defmodule GraphqlWeb.Resolvers.Menu do
  alias Graphql.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end
end
