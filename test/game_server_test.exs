defmodule GameServerTest do
  use ExUnit.Case
  alias Scrumpoker.{Game, Player, GameServer}

  test "test player join callback" do
    game = %Game{id: "test-game"}
    player = %Player{id: "test-player"}
    result = GameServer.handle_call({:player_join, player}, {}, game)
    updated_game = %Game{id: "test-game", players: [%Player{id: "test-player"}]}

    expected = {:reply, updated_game, updated_game}
    assert result == expected
  end
end
