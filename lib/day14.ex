defmodule Aoc2020.Day14 do
  @moduledoc """
  Solutions for Day 14.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 14 

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
