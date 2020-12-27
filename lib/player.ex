defmodule Scrumpoker.Player do
  defstruct id: "", vote: nil

  alias Scrumpoker.Player

  @doc """
  Creates new Player instance with given id.

  Name is unique validator of a Player instance for game.

  ## Examples

      iex> Scrumpoker.Player.new("test")
      %Scrumpoker.Player{id: "test", vote: nil}
  """
  def new(id) do
    %Player{id: id}
  end

  @doc """
  Casts player vote to player struct.

  ## Examples

      iex> player = %Scrumpoker.Player{id: "test"}
      iex> Scrumpoker.Player.cast_vote(player, 3)
      %Scrumpoker.Player{id: "test", vote: 3}
  """
  def cast_vote(%Player{} = player, vote) when is_number(vote) do
    %Player{player | vote: vote}
  end
end
