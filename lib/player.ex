defmodule Scrumpoker.Player do
  defstruct id: "", name: "", vote: nil

  alias Scrumpoker.Player

  @doc """
  Creates new Player instance with given id.

  Name is unique validator of a Player instance for game.

  ## Examples

      iex> Scrumpoker.Player.new("test")
      %Scrumpoker.Player{id: "test", vote: nil, name: ""}
  """
  def new(id) do
    %Player{id: id}
  end

  def clear_vote(player) do
    %Player{player | vote: nil}
  end

  @doc """
  Casts player vote to player struct.

  ## Examples

      iex> player = %Scrumpoker.Player{id: "test"}
      iex> Scrumpoker.Player.cast_vote(player, 3)
      %Scrumpoker.Player{id: "test", vote: 3, name: ""}
  """
  def cast_vote(%Player{} = player, vote) do
    converted_vote = vote |> convert_vote()
    %Player{player | vote: converted_vote}
  end

  defp convert_vote(vote) when is_number(vote) do
    vote
  end


  defp convert_vote(vote) do
    case vote do
      "☕" ->
        vote
      _ ->
        String.to_integer(vote)
    end
  end
end
