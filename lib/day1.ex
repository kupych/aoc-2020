defmodule Aoc2020.Day1 do
  @moduledoc """
  Solutions for Day 1.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 1

  @impl Day
  def a(numbers) do
    numbers
    |> Map.values()
    |> Enum.reduce_while(0, fn x, acc ->
      case Map.get(numbers, x) do
        nil -> {:cont, acc}
        answer -> {:halt, answer * x}
      end
    end)
  end

  @impl Day
  def b(numbers) do
    values = Map.values(numbers)

    Enum.reduce_while(values, 0, fn x, acc ->
      case Enum.find(values, fn y -> Map.get(numbers, x + y) end) do
        nil -> {:cont, acc}
        z -> {:halt, x * z * (2020 - x - z)}
      end
    end)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&{2020 - &1, &1})
      |> Map.new()
    end
  end
end
