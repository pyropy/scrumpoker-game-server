defmodule Scrumpoker.Game do
  @enforce_keys [:name]
  defstruct name: "", players: []

  alias Scrumpoker.{Game, Player}


  @doc """
  Creates new Game instance with given name.

  Name is unique validator of a Game instance.

  ## Examples

      iex> Scrumpoker.Game.new("test")
      %Scrumpoker.Game{name: "test", players: []}
  """
  def new(name) do
    %Game{name: name}
  end


  @doc """
  Adds player to game.

  If player already exists in game, previous
  player value is replaced with new one.

  ## Examples

      iex> game = %Scrumpoker.Game{name: "test"}
      iex> player = %Scrumpoker.Player{name: "test-player"}
      iex> Scrumpoker.Game.add_player(game, player)
      %Scrumpoker.Game{name: "test", players: [%Scrumpoker.Player{name: "test-player"}]}

      iex> player = %Scrumpoker.Player{name: "test-player"}
      iex> game = %Scrumpoker.Game{name: "test", players: [player]}
      iex> Scrumpoker.Game.add_player(game, player)
      %Scrumpoker.Game{name: "test", players: [%Scrumpoker.Player{name: "test-player"}]}

      iex> player = %Scrumpoker.Player{name: "test-player"}
      iex> game = %Scrumpoker.Game{name: "test", players: [player]}
      iex> player_with_vote = %Scrumpoker.Player{name: "test-player", vote: 3}
      iex> Scrumpoker.Game.add_player(game, player_with_vote)
      %Scrumpoker.Game{name: "test", players: [%Scrumpoker.Player{name: "test-player", vote: 3}]}

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
  Checks if player already in game and returns bool.

  ## Examples

      iex> game = %Scrumpoker.Game{name: "test"}
      iex> player = %Scrumpoker.Player{name: "test-player"}
      iex> Scrumpoker.Game.player_in_game(player, game)
      false

      iex> player = %Scrumpoker.Player{name: "test-player"}
      iex> game = %Scrumpoker.Game{name: "test", players: [player]}
      iex> Scrumpoker.Game.player_in_game(player, game)
      true

      iex> player = %Scrumpoker.Player{name: "test-player"}
      iex> game = %Scrumpoker.Game{name: "test", players: [player]}
      iex> player_with_vote = %Scrumpoker.Player{name: "test-player", vote: 10}
      iex> Scrumpoker.Game.player_in_game(player_with_vote, game)
      true
  """
  def player_in_game(%Player{} = player, %Game{players: players }) do
    !!Enum.find(players, fn in_game_player -> player.name == in_game_player.name end)
  end

  def update_player(%Game{players: []} = game, %Player{} = player) do
    %Game{game | players: [player]}
  end

  @doc """
  Adds player to game.

  If player already exists in game, previous
  player value is replaced with new one.

  If there is no players in game, player is
  simply added to game wihout replacing.

  ## Examples

      iex> player = %Scrumpoker.Player{name: "test-player"}
      iex> game = %Scrumpoker.Game{name: "test", players: [player]}
      iex> player_with_vote = %Scrumpoker.Player{name: "test-player", vote: 3}
      iex> Scrumpoker.Game.update_player(game, player_with_vote)
      %Scrumpoker.Game{name: "test", players: [%Scrumpoker.Player{name: "test-player", vote: 3}]}

      iex> player = %Scrumpoker.Player{name: "test-player"}
      iex> game = %Scrumpoker.Game{name: "test", players: []}
      iex> Scrumpoker.Game.update_player(game, player)
      %Scrumpoker.Game{name: "test", players: [%Scrumpoker.Player{name: "test-player"}]}
  """
  def update_player(%Game{players: players} = game, %Player{} = player) do
    index = get_player_index_in_players_list(players, player)
    players = List.replace_at(players, index, player)
    %Game{game | players: players}
  end

  defp get_player_index_in_players_list(players, player) do
    {_player, index} = Enum.with_index(players)
    |> Enum.find(fn {in_game_player, _index} -> player.name == in_game_player.name end)

    index
  end
end
