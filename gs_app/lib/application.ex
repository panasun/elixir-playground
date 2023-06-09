defmodule GsApp.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [PageProducer, PageConsumer]

    opts = [strategy: :one_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
