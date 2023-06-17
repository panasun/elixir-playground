defmodule PageConsumer do
  use GenStage
  # require Logger

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state)
  end

  def init(initial_state) do
    IO.puts("PageConsumer init")
    {:consumer, initial_state, subscribe_to: [{PageProducer, min_demand: 500, max_demand: 1000}]}
  end

  def handle_events(events, _from, state) do
    IO.puts("PageConsumer received #{inspect(events)}")

    Enum.each(events, fn _page ->
      Scraper.work()
    end)

    {:noreply, [], state}
  end
end
