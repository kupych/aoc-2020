defmodule Aoc2020.Day10 do
  @moduledoc """
  Solutions for Day 10.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 10

  @impl Day
  def a(adapters) do
    %{3 => three, 1 => one} =
      [0 | adapters]
      |> Enum.sort()
      |> find_joltage_differences()

    three * one
  end

  @impl Day
  def b(adapters) do
    adapters
    |> Enum.reduce(%{0 => 1}, &sum_previous_adapters/2)
    |> Map.values()
    |> Enum.at(-1)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
    end
  end

  def find_joltage_differences(adapters, acc \\ %{})

  def find_joltage_differences([_], acc) do
    Map.update(acc, 3, 1, &(&1 + 1))
  end

  def find_joltage_differences([current | [next | _] = adapters], acc) do
    find_joltage_differences(adapters, Map.update(acc, next - current, 1, &(&1 + 1)))
  end

  def sum_previous_adapters(key, acc) do
    sum =
      1..3
      |> Enum.map(&Map.get(acc, key - &1, 0))
      |> Enum.sum()

    IO.inspect("#{key} has #{sum} previous paths")
    Map.put(acc, key, Enum.max([sum, 1]))
  end
end
