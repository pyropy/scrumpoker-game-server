defmodule PlayerTest do
  use ExUnit.Case
  alias Scrumpoker.{Player}
  
  doctest Scrumpoker.Player


  test "create new player" do
    result = Player.new("test")
    expected = %Player{name: "test"} 
    assert result == expected
  end
end