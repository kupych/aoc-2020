defmodule Aoc2020.Day21 do
  @moduledoc """
  Solutions for Day 21.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 21 

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
