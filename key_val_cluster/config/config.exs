import Config

config :logger, handle_sasl_reports: true, level: :debug

config :libcluster, :topologies,
  cluster: [
    strategy: Cluster.Strategy.Epmd,
    config: [
      hosts: [:"node1@127.0.0.1", :"node2@127.0.0.1", :"node3@127.0.0.1"]
    ]
  ]
