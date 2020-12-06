defmodule Aoc2020.Day5 do
  @moduledoc """
  Solutions for Day 5.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 5

  @impl Day
  def a([ticket | _]), do: ticket

  @impl Day
  def b(tickets) do
    Enum.at(tickets, -1)..Enum.at(tickets, 0)
    |> Enum.find(&(!Enum.member?(tickets, &1)))
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_ticket/1)
      |> Enum.sort(:desc)
    end
  end

  def parse_ticket(ticket) do
    binary_id = Regex.replace(~r/\w/, ticket, fn x -> if x in ~w(R B), do: "1", else: "0" end)

    case Integer.parse(binary_id, 2) do
      {id, ""} -> id
      _ -> nil
    end
  end
end
