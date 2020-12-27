defmodule Scrumpoker.GameServer do
  # TODO Srdjan: Implement player leave
  use GenServer

  alias Scrumpoker.{Game, Player}

  def start_link({game_id})
  when is_binary(game_id) do
    IO.puts(__MODULE__)
    game_id = String.to_atom(game_id)
    start_link({game_id})
  end

  def start_link({game_id})
  when is_atom(game_id) do
    GenServer.start_link(__MODULE__, {game_id}, id: game_id)
  end

  def player_join(game_id, %Player{} = player)
  when is_binary(game_id) do
    String.to_atom(game_id)
    |> player_join(player)
  end

  def player_join(game_id, %Player{} = player)
  when is_atom(game_id) do
    GenServer.call(game_id, {:player_join, player})
  end

  def player_list(game_id) when is_binary(game_id) do
    game_id
    |> String.to_atom()
    |> player_list()
  end

  def player_list(game_id) when is_atom(game_id) do
    game_id
    |> GenServer.call(:player_list)
  end

  @impl true
  def init({game_id}) do
    {:ok, Game.new(game_id)}
  end

  @impl true
  def handle_call({:player_join, player}, _from, %Game{} = game) do
    updated_game = Game.add_player(game, player)
    {:reply, updated_game, updated_game}
  end

  @impl true
  def handle_call(:player_list, _from, %Game{} = game) do
    {:reply, game.players, game}
  end
end
