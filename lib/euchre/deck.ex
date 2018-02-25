defmodule Euchre.Deck do
  @moduledoc false

  @cards for suit <- [:clubs, :diamonds, :hearts, :spades],
             rank <- [9, 10, :queen, :king, :ace, :jack],
             do: %{suit: suit, rank: rank}

  defexception [:message]

  def shuffled() do
    Enum.shuffle(@cards)
  end

  def take(deck, n) when n < length(deck) do
    {:ok, Enum.take(deck, n), Enum.drop(deck, n)}
  end

  def take(_deck, _n) do
    raise Euchre.Deck, message: "overdrawn"
  end
end
