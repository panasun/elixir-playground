defmodule HelloWorldWeb.HelloWorld do
  use HelloWorldWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "hello world"})
  end
end
