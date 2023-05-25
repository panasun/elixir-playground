defmodule GraphqlWeb.HelloWorld do
  use GraphqlWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "hello world"})
  end
end
