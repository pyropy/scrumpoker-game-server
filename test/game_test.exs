defmodule GameTest do
  use ExUnit.Case
  alias Scrumpoker.{Game, Player}
  doctest Scrumpoker.Game

  test "create new game" do
    result = Game.new("test")
    expected = %Game{id: "test"}
    assert result == expected
  end

  test "add player to game empty players list" do
    player = %Player{id: "testko"}
    game = %Game{id: "game-id"}
    game = Game.add_player(game, player)
    result = game.players
    expected = [player]
    assert result == expected
  end

  test "add player to game populated layers list" do
    player = %Player{id: "testko"}
    player2 = %Player{id: "testko2"}
    game = %Game{id: "game-id", players: [player]}
    game = Game.add_player(game, player2)
    result = game.players
    expected = [player2, player]
    assert result == expected
  end

  test "add player to game, player already in players list" do
    player = %Player{id: "testko"}
    player2 = %Player{id: "testko2"}
    game = %Game{id: "game-id", players: [player]}
    game = Game.add_player(game, player2)
    game = Game.add_player(game, player2)
    result = game.players
    expected = [player2, player]
    assert result == expected
  end
end
