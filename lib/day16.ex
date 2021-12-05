defmodule Aoc2020.Day16 do
  @moduledoc """
  Solutions for Day 16.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @rule_regex ~r/(.*): (\d+)-(\d+) or (\d+)-(\d+)/
  @impl Day
  def day(), do: 16

  @impl Day
  def a(%{nearby: nearby, rules: rules}) do
    total = Enum.count(nearby)

    nearby
    |> Enum.map(&error_rate(&1, rules))
    |> Enum.sum()
  end

  @impl Day
  def b(%{nearby: nearby, your_ticket: yours, rules: rules}) do
    valid_ticket_columns =
      nearby
      |> Enum.filter(&valid_ticket?(&1, rules))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    departure_fields =
      Enum.map(rules, &find_field_indices(&1, valid_ticket_columns))
      |> narrow_down_possibilities()
      |> Enum.filter(fn
        {"departure" <> _, _} -> true
        _ -> false
      end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.map(&Enum.at(yours, &1))
      |> Enum.product()


  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, &parse_lines/2)
    end
  end

  defp parse_lines(line, %{mode: :nearby} = tickets) do
    nearby_ticket = parse_ticket(line)

    Map.update(tickets, :nearby, [nearby_ticket], fn x -> [nearby_ticket | x] end)
  end

  defp parse_lines(line, %{mode: :your_ticket} = tickets) do
    Map.merge(tickets, %{your_ticket: parse_ticket(line), mode: nil})
  end

  defp parse_lines("your ticket" <> _, tickets) do
    Map.put(tickets, :mode, :your_ticket)
  end

  defp parse_lines("nearby" <> _, tickets) do
    Map.put(tickets, :mode, :nearby)
  end

  defp parse_lines("", tickets) do
    tickets
  end

  defp parse_lines(line, tickets) do
    {rule, ranges} = parse_rule(line)
    Map.update(tickets, :rules, %{rule => ranges}, fn rules -> Map.put(rules, rule, ranges) end)
  end

  defp parse_ticket(line) do
    line
    |> String.split(",")
    g> Enum.map(&String.to_integer/1)
  end

  defp parse_rule(line) do
    [_ | [rule | ranges]] = Regex.run(@rule_regex, line)

    rule =
      rule
      |> String.replace(" ", "_")

    ranges =
      ranges
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(&range_from_list/1)

    {rule, ranges}
  end

  defp range_from_list([start_value, end_value]), do: start_value..end_value

  defp error_rate(ticket, rules) do
    valid_ranges =
      rules
      |> Map.values()
      |> List.flatten()

    ticket
    |> Enum.reject(&number_valid?(&1, valid_ranges))
    |> Enum.sum()
  end

  defp valid_ticket?(ticket, rules) do
    error_rate(ticket, rules) == 0
  end

  def valid_ranges?(ticket, rules) do
    valid_ranges =
      rules
      |> Map.values()
      |> List.flatten()

    Enum.all?(ticket, &number_valid?(&1, valid_ranges))
  end

  defp number_valid?(number, ranges) do
    Enum.any?(ranges, &Enum.member?(&1, number))
  end

  defp find_field_indices({rule, ranges}, ticket_columns) do
    ticket_columns = Enum.with_index(ticket_columns)
    valid_columns = Enum.filter(ticket_columns, &valid_ranges?(elem(&1, 0), %{rule => ranges}))
    {rule, Enum.map(valid_columns, &elem(&1, 1))}
  end

  defp narrow_down_possibilities(possibilities) do
    if Enum.all?(possibilities, &only_one_possibility/1) do
      possibilities
      |> Enum.map(fn {k, [v]} -> {k, v} end)
      |> Map.new()
    else
      values_to_remove =
        possibilities
        |> Enum.filter(&only_one_possibility/1)
        |> Enum.flat_map(&elem(&1, 1))

      possibilities
      |> Enum.map(&remove_possibilities(&1, values_to_remove))
      |> narrow_down_possibilities()
    end
  end

  defp only_one_possibility({_, [_]}), do: true
  defp only_one_possibility(_), do: false

  defp remove_possibilities({key, [_]} = rule, _) do
    rule
  end

  defp remove_possibilities({key, values} = rule, values_to_remove) do
    {key, values -- values_to_remove}
  end
end
