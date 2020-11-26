defmodule GameTest do
  use ExUnit.Case
  alias Scrumpoker.{Game, Player}
  doctest Scrumpoker.Game

  test "create new game" do
    result = Game.new("test")
    expected = %Game{name: "test"} 
    assert result == expected
  end

  test "add player to game empty players list" do
    player = %Player{name: "testko"}
    game = %Game{name: "game-name"}
    game = Game.add_player(game, player)
    result = game.players
    expected = [player]
    assert result == expected
  end

  test "add player to game populated layers list" do
    player = %Player{name: "testko"}
    player2 = %Player{name: "testko2"}
    game = %Game{name: "game-name", players: [player]}
    game = Game.add_player(game, player2)
    result = game.players
    expected = [player2, player]
    assert result == expected
  end

  test "add player to game, player already in players list" do
    player = %Player{name: "testko"}
    player2 = %Player{name: "testko2"}
    game = %Game{name: "game-name", players: [player]}
    game = Game.add_player(game, player2)
    game = Game.add_player(game, player2)
    result = game.players
    expected = [player2, player]
    assert result == expected
  end
end
