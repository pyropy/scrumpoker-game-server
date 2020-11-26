defmodule Scrumpoker.Player do
  defstruct name: "", vote: nil

  alias Scrumpoker.Player

  def new(name) do
    %Player{name: name}
  end

  def cast_vote(%Player{} = player, vote) when is_number(vote) do
    %Player{player | vote: vote}
  end
end
