defmodule GraphqlWeb.Schema.Query.MenuItemsTest do
  use GraphqlWeb.ConnCase, async: true

  @query """
    {
      menuItem {
        name
      }
    }
  """
  test "query: menu_item", %{conn: conn} do
    conn = get conn, "/", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{"menuItem" => %{"name" => "Bin"}}
           }
  end

  @query """
    {
      menuItems {
        name
      }
    }
  """
  test "query: menu_items", %{conn: conn} do
    conn = get conn, "/", query: @query
    IO.inspect(json_response(conn, 200))

    assert json_response(conn, 200) == %{
             "data" => %{"menuItems" => [%{"name" => "Bin"}, %{"name" => "Bin2"}]}
           }
  end
end
