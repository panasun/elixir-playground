defmodule Rabbitmq do
  use Broadway
  use AMQP

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: MyBroadway,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "my_queue",
           connection: [
             username: "guest",
             password: "guest"
           ],
           qos: [
             prefetch_count: 50
           ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 50
        ]
      ],
      batchers: [
        default: [
          batch_size: 3,
          batch_timeout: 1500,
          concurrency: 5
        ]
      ]
    )
  end

  def test do
    {:ok, connection} = AMQP.Connection.open("amqp://guest:guest@127.0.0.1")
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, "my_queue", durable: true)

    Enum.each(1..10, fn i ->
      AMQP.Basic.publish(channel, "", "my_queue", "#{i}")
    end)

    AMQP.Connection.close(connection)
  end

  @impl true
  def handle_message(_, message, _) do
    # IO.inspect("AAAA")
    # IO.inspect(message)

    message
    |> Message.update_data(fn data -> {"B", data, String.to_integer(data) * 2} end)
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    IO.inspect("BB")
    IO.inspect(messages)
    list = messages |> Enum.map(fn e -> e.data end)
    IO.inspect(list, label: "Got batch")
    messages
  end
end
