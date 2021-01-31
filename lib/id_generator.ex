defmodule Scrumpoker.IdGenerator do
  @moduledoc """
  Generates human readable ids.
  """

  @alphabet  ~w[a b c d e f g h i j k l m n o p q r s t u v w x y z]

  @doc """
  Generates random id by taking 9 random characters,
  chunks them into pair of three and joins with "-" in between
  """
  def generate do
    Stream.repeatedly(fn -> Enum.random(@alphabet) end)
    |> Stream.take(9)
    |> Stream.chunk_every(3)
    |> Enum.join("-")
  end
end
