defmodule ClusterApp.Application do
  use Application

  def start do
    children = [ClusterApp.Cluster]

    opts = [strategy: :one_for_one, name: ClusterApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
