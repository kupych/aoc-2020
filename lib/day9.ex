defmodule Aoc2020.Day9 do
  @moduledoc """
  Solutions for Day 9.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 9

  @impl Day
  def a(numbers) do
    25..(Enum.count(numbers) - 1)
    |> Enum.reduce_while({:valid, 0}, fn x, _ ->
      case last_25(x, numbers) do
        {:valid, _} -> {:cont, 0}
        {:invalid, number} -> {:halt, number}
      end
    end)
  end

  @impl Day
  def b(numbers) do
    invalid_number = a(numbers)
    contiguous = 
      numbers
      |> find_contiguous(invalid_number)
      |> Enum.sort()

    Enum.at(contiguous, 0) + Enum.at(contiguous, -1)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  def last_25(index, numbers) do
    number = Enum.at(numbers, index)
    last_25 = Enum.slice(numbers, index - 25, 25)
    combinations = for x <- last_25, y <- last_25, x != y, do: x + y

    if Enum.member?(combinations, number) do
      {:valid, number}
    else
      {:invalid, number}
    end
  end

  def find_contiguous([value | values], invalid) when value >= invalid, do: find_contiguous(values, invalid)

  def find_contiguous([value | values], invalid) do
    result = Enum.reduce_while(values, [value], fn x, acc ->
      acc = Enum.concat(acc, [x])
      sum = Enum.sum(acc)
      cond do
        sum > invalid -> {:halt, {:err, :over}}
        sum == invalid -> {:halt, {:ok, acc}}
        true -> {:cont, acc}
      end
    end)

    case result do
      {:ok, acc} -> acc
      _ -> find_contiguous(values, invalid)
    end
     
  end
    
end
