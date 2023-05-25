defmodule GraphqlWeb.Router do
  use GraphqlWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GraphqlWeb do
    pipe_through :api

    get "/hello-world", HelloWorld, :index
  end
end
