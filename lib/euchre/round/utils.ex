defmodule Euchre.Round.Utils do
  @moduledoc false

  alias Euchre.Round

  def notify_player(player, msg) do
    {:notify_player, player, msg}
  end

  def instructions_and_state(round) do
    {round.instructions, %Round{round | instructions: []}}
  end
end
