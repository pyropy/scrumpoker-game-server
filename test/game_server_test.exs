defmodule GameServerTest do
  use ExUnit.Case
  alias Scrumpoker.{Game, Player, GameServer}

  test "test player join callback" do
    game = %Game{name: "test-game"}
    player = %Player{name: "test-player"}
    result = GameServer.handle_call({:player_join, player}, {}, game)
    updated_game = %Game{name: "test-game", players: [%Player{name: "test-player"}]}

    expected = {:reply, updated_game, updated_game}
    assert result == expected
  end
end
