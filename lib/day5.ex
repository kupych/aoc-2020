defmodule Aoc2020.Day5 do
  @moduledoc """
  Solutions for Day 5.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 5

  @impl Day
  def a(tickets) do
    tickets
    |> Enum.sort_by(& &1.id, :desc)
    |> Enum.at(0)
  end

  @impl Day
  def b(_) do
    ""
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n")
      |> Enum.map(&parse_ticket/1)
    end
  end

  def parse_ticket(ticket) do
    binary_id = Regex.replace(~r/\w/, ticket, fn x -> if x in ~w(R B), do: "1", else: "0" end)
    IO.inspect(binary_id)
    {id, _} = Integer.parse(binary_id, 2)

    case Integer.parse(binary_id, 2) do
      {id, ""} ->
        %{
          col: rem(id, 8),
          id: id,
          row: div(id, 8)
        }

      _ ->
        IO.inspect("couldn't parse #{binary_id}")
        %{}
    end
  end
end
