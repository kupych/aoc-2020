defmodule Aoc2020.Day4 do
  @moduledoc """
  Solutions for Day 4.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.{Day, Passport}

  @impl Day
  def day(), do: 4

  @impl Day
  def a(passports) do
    passports
    |> Enum.map(&Passport.changeset(%Passport{}, &1))
    |> Enum.count(& &1.valid?)
  end

  @impl Day
  def b(passports) do
    passports
    |> Enum.map(&Passport.changeset(%Passport{}, &1, :strict))
    |> Enum.count(& &1.valid?)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split(~r/\s{2,}/)
      |> Enum.map(&parse_passport_data/1)
    end
  end

  def parse_passport_data(passport_string) do
    passport_string
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(&String.split(&1, ":"))
    |> IO.inspect()
    |> Enum.map(fn [k | [v]] -> {String.to_atom(k), v} end)
    |> Map.new()
  end
end
