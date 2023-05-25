defmodule HelloWorldWeb.Router do
  use HelloWorldWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWorldWeb do
    pipe_through :api

    get "/hello-world", HelloWorld, :index
  end
end
