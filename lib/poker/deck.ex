defmodule Poker.Deck do
  @ranks 2..14
  @suits [:spades, :hearts, :clubs, :diamonds]

  def new do
    for rank <- @ranks, suit <- @suits do
      %Poker.Card{rank: rank, suit: suit}
    end |> Enum.shuffle
  end
end