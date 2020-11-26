defmodule ScrumpokerTest do
  use ExUnit.Case
  doctest Scrumpoker

  test "greets the world" do
    assert Scrumpoker.hello() == :world
  end
end
