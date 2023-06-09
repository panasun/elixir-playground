defmodule KeyValCluster.Account do
  use GenServer

  def start_link(account_id) do
    GenServer.start_link(__MODULE__, account_id, name: via_tuple(account_id))
  end

  defp via_tuple(account_id) do
    {:via, Horde.Registry, {KeyValCluster.Registry, {KeyValCluster.Account, account_id}}}
  end

  defp via_tuple2(account_id) do
    {:via, Horde.Registry, {KeyValCluster.Registry, {KeyValCluster.Account2, account_id}}}
  end

  def via_tuple_auction(account_id) do
    {
      :via,
      Horde.Registry,
      {KeyValCluster.Registry, {KeyValCluster.Account.AuctionSupervisor, account_id}}
    }
  end

  def via_tuple_auction2(account_id) do
    {
      :via,
      Horde.Registry,
      {KeyValCluster.Registry, {KeyValCluster.Account.AuctionSupervisor2, account_id}}
    }
  end

  def init(account_id) do
    # children = [
    #   {
    #     Horde.DynamicSupervisor,
    #     [
    #       # name: via_tuple_auction(account_id),
    #       # name: :account1_auction,
    #       name: String.to_atom("Auction.SuperVisor" <> account_id),
    #       # name: KeyValCluster.AccountAuction1.Supervisor,
    #       strategy: :one_for_one,
    #       distribution_strategy: Horde.UniformQuorumDistribution,
    #       max_restarts: 5,
    #       max_seconds: 1,
    #       shutdown: 50_000,
    #       members: :auto
    #     ]
    #   }
    # %{
    #   id: KeyValCluster.Account.AuctionCluster,
    #   restart: :transient,
    #   start:
    #     {Task, :start_link,
    #      [
    #        fn ->
    #          Horde.DynamicSupervisor.wait_for_quorum(
    #            String.to_atom("Auction.SuperVisor" <> account_id),
    #            30_000
    #          )
    #        end
    #      ]}
    # }
    # ]

    # opts = [strategy: :one_for_one, name: String.to_atom("Auction.SuperVisor2" <> account_id)]
    # Supervisor.start_link(children, opts)

    # Horde.DynamicSupervisor.start_link(
    #   # name: via_tuple_auction(account_id),
    #   # name: :account1_auction,
    #   name: String.to_atom("Auction.SuperVisor" <> account_id),
    #   # name: KeyValCluster.AccountAuction1.Supervisor,
    #   strategy: :one_for_one,
    #   distribution_strategy: Horde.UniformQuorumDistribution,
    #   max_restarts: 5,
    #   max_seconds: 1,
    #   shutdown: 50_000,
    #   members: :auto
    # )

    Supervisor.start_link(
      [
        {
          DynamicSupervisor,
          name: via_tuple_auction(account_id)
        }
      ],
      strategy: :one_for_one
      # name: via_tuple_auction2(account_id)
    )

    data = KeyValCluster.DB.fetch(:account, account_id)
    {:ok, data || nil}
  end

  def maybe_spawn(account_id) do
    case length(
           Horde.Registry.lookup(KeyValCluster.Registry, {KeyValCluster.Account, account_id})
         ) do
      0 ->
        Horde.DynamicSupervisor.start_child(
          KeyValCluster.AccountSupervisor,
          {KeyValCluster.Account, account_id}
        )

      _ ->
        nil
    end
  end

  def update(account_id, value) do
    # GenServer.call(via_tuple(account_id), {:spawn, account_id})
    maybe_spawn(account_id)
    GenServer.cast(via_tuple(account_id), {:update, account_id, value})
  end

  def get(account_id) do
    # GenServer.call(via_tuple(account_id), {:spawn, account_id})
    maybe_spawn(account_id)
    GenServer.call(via_tuple(account_id), {:get, account_id})
  end

  def add_auction(account_id, auction_id) do
    DynamicSupervisor.start_child(
      via_tuple_auction(account_id),
      {KeyValCluster.Account.Auction, auction_id}
    )

    # GenServer.cast(via_tuple(account_id), {:add_auction, account_id, auction_id})
  end

  def handle_cast({:update, account_id, new_value}, value) do
    KeyValCluster.DB.save(:account, account_id, new_value)
    {:noreply, new_value}
  end

  def handle_call({:get, account_id}, _, value) do
    {:reply, value, value}
  end

  # def handle_cast({:add_auction, account_id, auction_id}, value) do
  #   Horde.DynamicSupervisor.start_child(
  #     # {KeyValCluster.Account.AuctionSupervisor, account_id},
  #     via_tuple_auction_supervisor(account_id),
  #     {KeyValCluster.Account.Auction, account_id, auction_id}
  #   )

  #   {:reply, {account_id, auction_id}}
  # end
end

# defmodule KeyValCluster.Account.AuctionSupervisor do
#   use Horde.DynamicSupervisor

#   def start_link(account_id) do
#     Horde.DynamicSupervisor.start_link(__MODULE__, account_id, name: via_tuple(account_id))
#   end

#   def via_tuple(account_id) do
#     {
#       :via,
#       Horde.Registry,
#       {KeyValCluster.Registry, {KeyValCluster.Account.AuctionSupervisor, account_id}}
#     }
#   end

#   def init(init_arg) do
#     [strategy: :one_for_one]
#     |> Keyword.merge(init_arg)
#     |> Horde.DynamicSupervisor.init()
#   end
# end

defmodule KeyValCluster.Account.Auction do
  use GenServer

  def start_link(auction_id) do
    GenServer.start_link(__MODULE__, auction_id, name: via_tuple(auction_id))
  end

  defp via_tuple(auction_id) do
    {:via, Horde.Registry, {KeyValCluster.Registry, {KeyValCluster.Account.Auction, auction_id}}}
  end

  def init(auction_id) do
    {:ok, auction_id}
  end
end
