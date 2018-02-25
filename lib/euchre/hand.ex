defmodule Euchre.Hand do
  @moduledoc false

  @hand_size 5

  alias __MODULE__
  alias Euchre.Deck

  defstruct [:cards]

  def new(deck) do
    {:ok, cards, deck} = Deck.take(deck, @hand_size)
    {:ok, %Hand{cards: cards}, deck}
  end
end
