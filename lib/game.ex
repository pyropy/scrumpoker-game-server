defmodule Scrumpoker.Game do
  @moduledoc """
  Holds main server (business) logic.

  # TODO: Change players from list to map
  """
  @enforce_keys [:id]
  defstruct id: "", players: [], password: nil, topic_name: nil, vote_reveal: false
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

  def player_vote(%Player{} = player, %Game{} = game, vote) do
    player_with_vote = Player.cast_vote(player, vote)
    Game.update_player(game, player_with_vote)
        |> Game.reveal_votes_if_round_is_over()
  end

  @doc """
  Updates existing player in the game.

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

  @doc """
  Updates game topic name.

  ## Examples

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: [], topic_name: "Old Topic Name"}
      iex> Scrumpoker.Game.update_topic(game, player, "New Topic Name")
      %Scrumpoker.Game{id: "test", players: [], topic_name: "New Topic Name"}
  """
  def update_topic(%Game{} = game, %Player{} = _player, new_topic_name) do
    # TODO: Add checks to see if user is admin / moderator
    %Game{game | topic_name: new_topic_name}
  end

  @doc """
  Sets vote reveal to given value.

  ## Examples

      iex> game = %Scrumpoker.Game{id: "test", players: []}
      iex> Scrumpoker.Game.vote_reveal(game, true)
      %Scrumpoker.Game{id: "test", players: [], vote_reveal: true}
  """
  def vote_reveal(%Game{} = game, is_revealed?) do
    %Game{game | vote_reveal: is_revealed?}
  end

  @doc """
  Sets vote reveal to given value if player is admin.

  ## Examples

      iex> player = %Scrumpoker.Player{id: "test-player"}
      iex> game = %Scrumpoker.Game{id: "test", players: []}
      iex> Scrumpoker.Game.vote_reveal(game, player, true)
      %Scrumpoker.Game{id: "test", players: [], vote_reveal: true}
  """
  def vote_reveal(%Game{} = game, %Player{} = _player, is_revealed?) do
    # TODO: Add checks to see if user is admin / moderator
    %Game{game | vote_reveal: is_revealed?}
  end

  def reveal_votes_if_round_is_over(game) do
    case round_is_over?(game) do
      true ->
        vote_reveal(game, true)
      _ -> game
    end
  end

  @doc """
  Resets votes for every player in the game.

  ## Examples

      # iex> player_with_vote = %Scrumpoker.Player{id: "test-player", vote: 10}
      # iex> player_without_vote = %Scrumpoker.Player{id: "test-player", vote: nil}
      # iex> game = %Scrumpoker.Game{id: "test", players: [player_with_vote]}
      # iex> Scrumpoker.Game.reset_votes(game)
      # %Scrumpoker.Game{id: "test", players: [player_without_vote]}
  """
  def reset_votes(game) do
    updated_players = game.players |> Enum.map(&Player.clear_vote/1)
    %Game{game | players: updated_players, vote_reveal: false}
  end

  defp get_player_index_in_players_list(players, player) do
    {_player, index} = Enum.with_index(players)
    |> Enum.find(fn {in_game_player, _index} -> player.id == in_game_player.id end)

    index
  end

  defp filter_list_nil_and_false_values(some_list) do
    Enum.filter(some_list, & &1)
  end

  # Round is over if all players have voted
  defp round_is_over?(game) do
    Enum.all?(game.players, fn player -> player.vote != nil end)
  end
end
