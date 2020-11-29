defmodule Scrumpoker.GameServer do

  # TODO Srdjan: Implement player leave
  use GenServer

  alias Scrumpoker.{Game, Player}

  def start_link({game_name}) do
    GenServer.start_link(__MODULE__, {game_name})
  end

  def player_join(pid, %Player{} = player) do
    GenServer.call(pid, {:player_join, player})
  end

  @impl true
  def init({game_name}) do
    {:ok, Game.new(game_name)}
  end

  @impl true
  def handle_call({:player_join, player}, _from, %Game{} = game) do
    {:reply, Game.add_player(game, player)}
  end
end
