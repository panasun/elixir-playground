defmodule ClusterApp.Cluster do
  def start_link do
    Libcluster.start_link(name: :my_cluster, topologies: [:example])
  end
end
