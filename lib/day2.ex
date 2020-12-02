defmodule Aoc2020.Day2 do
  @moduledoc """
  Solutions for Day 2.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 2

  @impl Day
  def a(passwords) do
    Enum.reduce(passwords, 0, &validate_password_a/2)
  end

  @impl Day
  def b(passwords) do
    Enum.reduce(passwords, 0, &validate_password_b/2)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_password/1)
    end
  end

  def parse_password(password) do
    case String.split(password) do
      [range, policy, password] ->
        [first, last] = parse_range(range)
        {first, last, String.first(policy), password}
    end
  end

  def parse_range(range) do
    range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  def validate_password_a({first, last, policy, password}, acc) do
    with {:ok, regex} <- Regex.compile(policy) do
      if Enum.member?(first..last, Enum.count(Regex.scan(regex, password))) do
        acc + 1
      else
        acc
      end
    end
  end

  def validate_password_b({first, last, policy, password}, acc) do
    case {String.at(password, first - 1), String.at(password, last - 1)} do
      {^policy, ^policy} -> acc
      {^policy, _} -> acc + 1
      {_, ^policy} -> acc + 1
      _ -> acc
    end
  end
end
