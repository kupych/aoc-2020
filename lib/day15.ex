defmodule Aoc2020.Day15 do
  @moduledoc """
  Solutions for Day 15.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 15

  @impl Day
  def a(numbers) do
    1..2021
    |> Enum.reduce(%{initial: numbers ++ [0]}, &speak/2)
    |> Enum.find_value(fn {k, 2020} -> k
                          _ -> false
    end)
  end

  @impl Day
  def b(numbers) do
    1..30000001
    |> Enum.reduce(%{initial: numbers ++ [0]}, &speak/2)
    |> Enum.find_value(fn {k, 30000000} -> k
                          _ -> false
    end)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.trim()
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  defp speak(turn, %{initial: [number | rest]} = game) do
    case Map.get(game, :last_spoken) do
      nil ->
        game
        |> Map.put(:initial, rest)
        |> Map.put(:last_spoken, number)
        |> IO.inspect()

      last_spoken ->
        game
        |> Map.put(last_spoken, turn - 1)
        |> Map.put(:last_spoken, number)
        |> Map.put(:initial, rest)
        |> IO.inspect()
    end
  end

  defp speak(turn, %{last_spoken: last_spoken} = game) do
    case Map.get(game, last_spoken) do
      nil ->
        game
        |> Map.put(last_spoken, turn - 1)
        |> Map.put(:last_spoken, 0)

      last_turn ->
        game
        |> Map.put(:last_spoken, (turn - 1) - last_turn)
        |> Map.put(last_spoken, turn - 1)
    end
  end
end
