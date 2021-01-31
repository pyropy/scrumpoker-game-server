defmodule Scrumpoker.Game do
  @moduledoc """
  Holds main server (business) logic.
  """
  @enforce_keys [:id]
  defstruct id: "", players: [], password: nil
    alias Scrumpoker.{Game, Player}

  @doc """
  Creates new Game instance with given id.

  Name is unique validator of a Game instance.

  ## Examples

      iex> Scrumpoker.Game.new("test")
      %Scrumpoker.Game{id: "test", players: []}
  """
  def new(id) do
    %Game{id: id}
  end


  @doc """
  Adds player to game.

  If player already exists in game, previous
  player value is replaced with new one.

  ## Examples

      iex> game = %Scrumpoker.Game{id: "test"}
      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> Scrumpoker.Game.add_player(game, player)
      %Scrumpoker.Game{id: "test", players: [%Scrumpoker.Player{id: "test-player"}]}

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> Scrumpoker.Game.add_player(game, player)
      %Scrumpoker.Game{id: "test", players: [%Scrumpoker.Player{id: "test-player"}]}

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> player_with_vote = %Scrumpoker.Player{id: "test-player", vote: 3}
      iex> Scrumpoker.Game.add_player(game, player_with_vote)
      %Scrumpoker.Game{id: "test", players: [%Scrumpoker.Player{id: "test-player", vote: 3}]}
  """
  def add_player(%Game{players: players} = game, %Player{} = player) do
    case player_in_game(player, game) do
      false ->
        %Game{game | players: [ player | players]}
      _ ->
        update_player(game, player)
    end
  end

  @doc """
  Adds player to game.

  If player already exists in game, previous
  player value is replaced with new one.

  ## Examples

      iex> game = %Scrumpoker.Game{id: "test"}
      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> Scrumpoker.Game.player_leave(game, player)
      %Scrumpoker.Game{id: "test", players: []}

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> Scrumpoker.Game.player_leave(game, player)
      %Scrumpoker.Game{id: "test", players: []}

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> player_with_vote = %Scrumpoker.Player{id: "test-player", vote: 3}
      iex> Scrumpoker.Game.player_leave(game, player_with_vote)
      %Scrumpoker.Game{id: "test", players: []}
  """
  def player_leave(%Game{} = game, %Player{} = player) do
    case player_in_game(player, game) do
      true ->
        update_player(game, player, nil)
      _ ->
        game
    end
  end


  @doc """
  Checks if player already in game and returns bool.

  ## Examples

      iex> game = %Scrumpoker.Game{id: "test"}
      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> Scrumpoker.Game.player_in_game(player, game)
      false

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> Scrumpoker.Game.player_in_game(player, game)
      true

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> player_with_vote = %Scrumpoker.Player{id: "test-player", vote: 10}
      iex> Scrumpoker.Game.player_in_game(player_with_vote, game)
      true
  """
  def player_in_game(%Player{} = player, %Game{players: players }) do
    !!Enum.find(players, fn in_game_player -> player.id == in_game_player.id end)
  end

  @doc """
  Updates existing player in the game.
  #
  ## Examples

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> player_with_vote = %Scrumpoker.Player{id: "test-player", vote: 3}
      iex> Scrumpoker.Game.update_player(game, player_with_vote)
      %Scrumpoker.Game{id: "test", players: [%Scrumpoker.Player{id: "test-player", vote: 3}]}
    """
  def update_player(%Game{players: players} = game, %Player{} = player) do
    index = get_player_index_in_players_list(players, player)
    players = List.replace_at(players, index, player)
    filtered_players = filter_list_nil_and_false_values(players)
    %Game{game | players: filtered_players}
  end


  @doc """
  Updates player with new given value.

  ## Examples

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> player_with_vote = %Scrumpoker.Player{id: "test-player", vote: 3}
      iex> Scrumpoker.Game.update_player(game, player, player_with_vote)
      %Scrumpoker.Game{id: "test", players: [%Scrumpoker.Player{id: "test-player", vote: 3}]}

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [player]}
      iex> Scrumpoker.Game.update_player(game, player, nil)
      %Scrumpoker.Game{id: "test", players: []}
  """
  def update_player(%Game{players: players} = game, %Player{} = player, new_value) do
    index = get_player_index_in_players_list(players, player)
    players = List.replace_at(players, index, new_value)
    filtered_players = filter_list_nil_and_false_values(players)
    %Game{game | players: filtered_players}
  end

  defp get_player_index_in_players_list(players, player) do
    {_player, index} = Enum.with_index(players)
    |> Enum.find(fn {in_game_player, _index} -> player.id == in_game_player.id end)

    index
  end

  defp filter_list_nil_and_false_values(some_list) do
    Enum.filter(some_list, & &1)
  end
end
