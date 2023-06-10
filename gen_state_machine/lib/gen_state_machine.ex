defmodule Game do
  require Logger

  @behaviour :gen_statem

  @countdown_duration 5_000
  @game_timeout 60_000
  @round_timeout 20_000

  def start_link do
    :gen_statem.start_link(__MODULE__, [], [])
  end

  def place_ship(pid, player, position) do
    :gen_statem.call(pid, {:place_ship, %{player: player, position: position}})
  end

  def mark_ready(pid, player) do
    :gen_statem.call(pid, {:mark_ready, player})
  end

  def shoot(pid, player, position) do
    :gen_statem.call(pid, {:shoot, %{player: player, position: position}})
  end

  def init(_) do
    initial_player_state = %{
      ships: MapSet.new(),
      ready?: false
    }

    {:ok, :setup, %{player_one: initial_player_state, player_two: initial_player_state}}
  end

  def callback_mode() do
    [:handle_event_function, :state_enter]
  end

  def handle_event(:enter, old_state, current_state, _data) do
    log_state(old_state, current_state)

    if current_state == :end do
      {:stop, :normal}
    else
      :keep_state_and_data
    end
  end

  def handle_event(
        {:call, from},
        {:place_ship, %{player: player, position: position}},
        :setup,
        data
      ) do
    data = place_player_ship(data, player, position)

    {:keep_state, data, {:reply, from, :ok}}
  end

  def handle_event({:call, from}, {:mark_ready, player}, :setup, data) do
    data = mark_player_ready(data, player)
    IO.inspect(data)

    if both_players_ready?(data) do
      {:next_state, :countdown, data,
       [{:reply, from, :ok}, {:state_timeout, @countdown_duration, :countdown_end}]}
    else
      {:keep_state, data, {:reply, from, :ok}}
    end
  end

  def handle_event({:call, _from}, {:shoot, _}, :countdown, _) do
    {:keep_state_and_data, :postpone}
  end

  def handle_event(:state_timeout, :countdown_end, :countdown, data) do
    {:next_state, {:game, :player_one}, data,
     [{{:timeout, :game}, @game_timeout, :game_end}, @round_timeout]}
  end

  def handle_event(
        {:call, from},
        {:shoot, %{player: player, position: position}},
        {:game, player},
        data
      ) do
    IO.inspect(data)
    data = delete_player_ship(data, get_other_player(player), position)
    IO.inspect(data)

    if end_game?(data) do
      {:next_state, :end, data, [{:reply, from, :ok}, {{:timeout, :game}, :cancel}]}
    else
      {:next_state, {:game, get_other_player(player)}, data,
       [{:reply, from, :ok}, @round_timeout]}
    end
  end

  def handle_event(:timeout, _value, {:game, player}, data) do
    {:next_state, get_other_player(player), @round_timeout}
  end

  def handle_event({:timeout, :game}, :game_end, {:game, _}, data) do
    {:next_state, :end, data}
  end

  def handle_event({:call, from}, _, _, _) do
    {:keep_state_and_data, {:reply, from, :error}}
  end

  defp place_player_ship(data, player, position) do
    update_in(data, [player, :ships], &MapSet.put(&1, position))
  end

  defp mark_player_ready(data, player) do
    put_in(data, [player, :ready?], true)
  end

  defp both_players_ready?(%{player_one: %{ready?: one_ready?}, player_two: %{ready?: two_ready?}}) do
    one_ready? && two_ready?
  end

  defp delete_player_ship(data, player, position) do
    update_in(data, [player, :ships], &MapSet.delete(&1, position))
  end

  defp end_game?(data) do
    Enum.empty?(data.player_one.ships) || Enum.empty?(data.player_two.ships)
  end

  defp get_other_player(:player_one) do
    :player_two
  end

  defp get_other_player(_) do
    :player_one
  end

  defp log_state(old_state, new_state) do
    Logger.info("""
    #{inspect(old_state)} -> #{inspect(new_state)}
    """)
  end
end
