defmodule Scrumpoker.GameServer do
  # TODO Srdjan: Implement player leave
  use GenServer

  alias Scrumpoker.{Game, Player}

  def start_link({game_name})
  when is_binary(game_name) do
    IO.puts(__MODULE__)
    game_name = String.to_atom(game_name)
    start_link({game_name})
  end

  def start_link({game_name})
  when is_atom(game_name) do
    GenServer.start_link(__MODULE__, {game_name}, name: game_name)
  end

  @spec player_join(atom | binary, Scrumpoker.Player.t()) :: any
  def player_join(game_name, %Player{} = player)
  when is_binary(game_name) do
    String.to_atom(game_name)
    |> player_join(player)
  end

  def player_join(game_name, %Player{} = player)
  when is_atom(game_name) do
    GenServer.call(game_name, {:player_join, player})
  end

  @impl true
  def init({game_name}) do
    {:ok, Game.new(game_name)}
  end

  @impl true
  def handle_call({:player_join, player}, _from, %Game{} = game) do
    updated_game = Game.add_player(game, player)
    {:reply, updated_game, updated_game}
  end
end
