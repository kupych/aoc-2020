defmodule Aoc2020.Day3 do
  @moduledoc """
  Solutions for Day 3.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 3

  @impl Day
  def a(map) do
    ski(map, {3, 1})
  end

  @impl Day
  def b(map) do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(&ski(map, &1))
    |> Enum.reduce(1, &Kernel.*/2)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(&Stream.cycle/1)
    end
  end

  def ski(map, distance) do
    map
    |> Enum.with_index()
    |> Enum.reduce({0, 0}, &ski_row(&1, &2, distance))
    |> elem(1)
  end

  def ski_row({_, y}, {x, tree_count}, {_, dy}) when rem(y, dy) > 0, do: {x, tree_count}

  def ski_row({row, _}, {x, tree_count}, {dx, _}) do
    case Enum.at(row, x) do
      "#" -> {x + dx, tree_count + 1}
      _ -> {x + dx, tree_count}
    end
  end
end
