defmodule Aoc2020.Day17 do
  @moduledoc """
  Solutions for Day 17.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 17

  @impl Day
  def a(_) do
    ""
  end

  @impl Day
  def b(_) do
    ""
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
    end
  end

end

defmodule Aoc2020.ConwayCube do
  defstruct cells: %{}

  
end
