defmodule KeyValCluster.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      [
        {
          Horde.Registry,
          [name: KeyValCluster.Registry, keys: :unique, members: :auto]
        },
        {
          Horde.DynamicSupervisor,
          [
            name: KeyValCluster.KeyValSupervisor,
            strategy: :one_for_one,
            distribution_strategy: Horde.UniformQuorumDistribution,
            max_restarts: 100_000,
            max_seconds: 1,
            shutdown: 50_000,
            members: :auto
          ]
        },
        {
          Horde.DynamicSupervisor,
          [
            name: KeyValCluster.DBSupervisor,
            strategy: :one_for_one,
            distribution_strategy: Horde.UniformQuorumDistribution,
            max_restarts: 5,
            max_seconds: 1,
            shutdown: 50_000,
            members: :auto
          ]
        },
        {
          Horde.DynamicSupervisor,
          [
            name: KeyValCluster.DBSupervisor,
            strategy: :one_for_one,
            distribution_strategy: Horde.UniformQuorumDistribution,
            max_restarts: 5,
            max_seconds: 1,
            shutdown: 50_000,
            members: :auto
          ]
        },
        {
          Horde.DynamicSupervisor,
          [
            name: KeyValCluster.MessageBrokerSupervisor,
            strategy: :one_for_one,
            distribution_strategy: Horde.UniformQuorumDistribution,
            max_restarts: 5,
            max_seconds: 1,
            shutdown: 50_000,
            members: :auto
          ]
        },
        %{
          id: KeyValCluster.ClusterConnector,
          restart: :transient,
          start:
            {Task, :start_link,
             [
               fn ->
                 Horde.DynamicSupervisor.wait_for_quorum(KeyValCluster.DBSupervisor, 30_000)

                 Horde.DynamicSupervisor.wait_for_quorum(
                   KeyValCluster.MessageBrokerSupervisor,
                   30_000
                 )

                 Horde.DynamicSupervisor.wait_for_quorum(KeyValCluster.KeyValSupervisor, 30_000)
                 Horde.DynamicSupervisor.wait_for_quorum(KeyValCluster.AccountSupervisor, 30_000)

                 KeyValCluster.DB.create()
               end
             ]}
        }
      ]
      |> maybe_start_cluster_supervisor(Mix.env())

    opts = [strategy: :one_for_one, name: KeyValCluster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp maybe_start_cluster_supervisor(children, :test), do: children

  defp maybe_start_cluster_supervisor(children, _) do
    [{Cluster.Supervisor, [Application.get_env(:libcluster, :topologies)]} | children]
  end
end
