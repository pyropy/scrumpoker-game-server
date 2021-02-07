defmodule Scrumpoker.GameServer do
  use GenServer

  alias Scrumpoker.{Game, Player}

  def start_link(options) do
    GenServer.start_link(__MODULE__, options, name: via_tuple(options[:id]))
  end

  def player_join(game_id, %Player{} = player) do
    GenServer.call(via_tuple(game_id), {:player_join, player})
  end

  def player_list(game_id) do
    GenServer.call(via_tuple(game_id), :player_list)
  end

def player_vote(game_id, player, vote) do
    GenServer.call(via_tuple(game_id), {:player_vote, player, vote})
  end

  defp via_tuple(game_id) do
    {:via, Registry, {Scrumpoker.GameRegistry, game_id}}
  end

  @impl true
  def init(options) do
    {:ok, %Game{id: options[:id]}}
  end

  @impl true
  def handle_call(:game_state, _from, %Game{} = game) do
    {:reply, game, game}
  end

  @impl true
  def handle_call({:player_join, player}, _from, %Game{} = game) do
    updated_game = Game.add_player(game, player)
    {:reply, updated_game, updated_game}
  end

  @impl true
  def handle_call({:player_leave, player}, _from, %Game{} = game) do
    updated_game = Game.player_leave(game, player)
    {:reply, updated_game, updated_game}
  end

  @impl true
  def handle_call({:player_vote, player, vote}, _from, %Game{} = game) do
    updated_game = Game.update_player(game, %Player{player | vote: vote})
    {:reply, updated_game, updated_game}
  end
end
