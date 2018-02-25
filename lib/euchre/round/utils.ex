defmodule Euchre.Round.Utils do
  @moduledoc false

  alias Euchre.Round

  def notify_player(player, msg) do
    {:notify_player, player, msg}
  end

  def notify_players(%Round{players: players, instructions: instructions} = round, msg) do
    %Round{round | instructions: Enum.map(players, &notify_player(&1, msg)) ++ instructions}
  end

  def instructions_and_state(round) do
    {round.instructions, %Round{round | instructions: []}}
  end
end
