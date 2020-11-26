defmodule Scrumpoker.Player do
  defstruct name: "", vote: nil

  alias Scrumpoker.Player

  @doc """
  Creates new Player instance with given name.

  Name is unique validator of a Player instance for game.

  ## Examples

      iex> Scrumpoker.Player.new("test")
      %Scrumpoker.Player{name: "test", vote: nil}
  """
  def new(name) do
    %Player{name: name}
  end

  @doc """
  Casts player vote to player struct.

  ## Examples

      iex> player = %Scrumpoker.Player{name: "test"}
      iex> Scrumpoker.Player.cast_vote(player, 3)
      %Scrumpoker.Player{name: "test", vote: 3}
  """
  def cast_vote(%Player{} = player, vote) when is_number(vote) do
    %Player{player | vote: vote}
  end
end
