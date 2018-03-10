defmodule Euchre.Round do
  @moduledoc false

  alias __MODULE__
  alias Euchre.{Deck, Round.Utils}

  defstruct current_phase: :bid,
            deck: Deck.shuffled(),
            instructions: [],
            players: [],
            players_left: [],
            trump: nil

  def start(players) do
    rotate(players)
    |> List.foldr(%Round{}, &deal_hand/2)
    |> next_move_notifier(:bid)
    |> Utils.instructions_and_state()
  end

  def bid(%Round{players_left: [player]} = round, player, bid) do
    case bid do
      :pass ->
        {:error, :cannot_pass}

      _ ->
        handle_bid(round, bid)
    end
  end

  def bid(%Round{players_left: [player | _rest]} = round, player, bid) do
    handle_bid(round, bid)
    |> Utils.instructions_and_state()
  end

  def bid(_round, _player, _msg), do: {:error, :move_unauthorized}

  defp deal_hand(player, round) do
    {:ok, hand, deck} = Euchre.Hand.new(round.deck)

    round
    |> Map.put(:deck, deck)
    |> Map.put(:instructions, [
      Utils.notify_player(player, {:deal_hand, hand}) | round.instructions
    ])
    |> Map.put(:players, [player | round.players])
    |> Map.put(:players_left, [player | round.players])
  end

  defp handle_bid(%Round{players_left: [_current, next | rest], players: players} = round, bid) do
    case bid do
      :order_up ->
        round
        |> Map.put(:instructions, [Utils.notify_player(List.first(players), :play)])
        |> Map.put(:players_left, players)
        |> Map.put(:trump, List.first(round.deck).suit)

      {:pick_trump, suit} when suit in [:clubs, :diamonds, :hearts, :spades] ->
        round
        |> Map.put(:instructions, [Utils.notify_player(List.first(players), :play)])
        |> Map.put(:players_left, players)
        |> Map.put(:trump, suit)

      :pass ->
        round
        |> Map.put(:instructions, [Utils.notify_player(next, :bid)])
        |> Map.put(:players_left, [next | rest])
    end
  end

  defp next_move_notifier(%Round{players_left: [player | _rest]} = round, msg) do
    round
    |> Map.update!(:instructions, fn instructions ->
      instructions ++ [Utils.notify_player(player, msg)]
    end)
  end

  defp rotate([dealer | rest]) do
    rest ++ [dealer]
  end
end
