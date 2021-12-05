defmodule Aoc2020.Day14 do
  @moduledoc """
  Solutions for Day 14.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 14

  @impl Day
  def a(lines) do
    lines
    |> Enum.reduce(%{}, &update_memory/2)
    |> Map.delete(:mask)
    |> Map.values()
    |> Enum.sum()
  end

  @impl Day
  def b(lines) do
    lines
    |> Enum.reduce(%{}, &update_memory_v2/2)
    |> Map.delete(:mask)
    |> Map.values()
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)
    end
  end

  def parse_line("mask = " <> bitmask) do
    {:mask, String.to_charlist(bitmask)}
  end

  def parse_line("mem[" <> string) do
    [address, value] = String.split(string, ~r/\D+/, trim: true)

    {String.to_integer(address), String.to_integer(value)}
  end

  def update_memory({:mask, mask}, %{} = memory) do
    Map.put(memory, :mask, mask)
  end

  def update_memory({address, value}, %{mask: mask} = memory) do
    masked_value =
      mask
      |> Enum.zip(integer_to_binary(value))
      |> Enum.map(&maybe_mask_value/1)
      |> binary_to_integer()

    Map.put(memory, address, masked_value)
  end

  def update_memory_v2({:mask, mask}, %{} = memory) do
    Map.put(memory, :mask, mask)
  end

  def update_memory_v2({address, value}, %{mask: mask} = memory) do
    mask
    |> Enum.zip(integer_to_binary(address))
    |> Enum.map(&maybe_mask_value_v2/1)
    |> generate_possible_combinations()
    |> Enum.map(&binary_to_integer/1)
    |> Enum.reduce(memory, &Map.put(&2, &1, value))
  end

  def maybe_mask_value({?X, value}), do: value
  def maybe_mask_value({masked, _}), do: masked

  def integer_to_binary(value) do
    value
    |> Integer.to_string(2)
    |> String.pad_leading(36, ["0"])
    |> String.to_charlist()
  end

  def binary_to_integer(value) do
    value
    |> to_string()
    |> String.to_integer(2)
  end

  def maybe_mask_value_v2({?0, value}), do: value
  def maybe_mask_value_v2({masked, _}), do: masked

  def generate_possible_combinations(value, prefix \\ [])

  def generate_possible_combinations([], prefix) do
    [prefix]
  end

  def generate_possible_combinations([?X | rest], prefix) do
    generate_possible_combinations(rest, prefix ++ [?0]) ++
      generate_possible_combinations(rest, prefix ++ [?1])
  end

  def generate_possible_combinations([value | rest], prefix) do
    generate_possible_combinations(rest, prefix ++ [value])
  end
end
