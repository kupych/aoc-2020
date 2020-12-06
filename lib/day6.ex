defmodule Aoc2020.Day6 do
  @moduledoc """
  Solutions for Day 6.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 6

  @impl Day
  def a(forms) do
    union = &MapSet.union/2
    forms
    |> Enum.map(&size_of_matching(&1, MapSet.new(), union))
    |> Enum.reduce(0, &+/2)
  end

  @impl Day
  def b(forms) do
    intersect = &MapSet.intersection/2
    alphaset =
      "abcdefghijklmnopqrstuvwxyz"
      |> String.codepoints()
      |> MapSet.new()

    forms
    |> Enum.map(&size_of_matching(&1, alphaset, intersect))
    |> Enum.reduce(0, &+/2)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split(~r/\n{2,}/, trim: true)
      |> Enum.map(&parse_questions/1)
    end
  end

  def parse_questions(questions) do
    questions
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&MapSet.new/1)
  end

  def size_of_matching(answers, default, function) do
    answers
    |> Enum.reduce(default, function)
    |> MapSet.size()
  end
end
