defmodule Aoc2020.Day7 do
  @moduledoc """
  Solutions for Day 7.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 7

  @impl Day
  def a(bags) do
    bags
    |> find_all_outer_bags("shiny gold")
    |> Enum.count()
  end

  @impl Day
  def b(bags) do
    find_all_inner_bags(bags, "shiny gold")
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, &add_bag/2)
    end
  end

  def add_bag(bag, acc) do
    [_, bag_name, inner_bags] = Regex.run(~r/^(.+?) bags contain (.+?)$/, bag)

    inner_bags =
      ~r/(\d+?) (.+?) bags?[.,]/
      |> Regex.scan(inner_bags)
      |> Enum.map(fn [_, number, bag] -> {bag, String.to_integer(number)} end)
      |> Map.new()

    acc = Map.update(acc, bag_name, %{contained_in: [], contains: inner_bags}, &Map.put(&1, :contains, inner_bags))

    Enum.reduce(inner_bags, acc, &add_contained_in(&1, &2, bag_name))
  end

  def add_contained_in({inner_bag, _}, acc, outer_bag) do
    Map.update(
      acc,
      inner_bag,
      %{contained_in: [outer_bag]},
      &Map.update(&1, :contained_in, [outer_bag], fn bags -> [outer_bag | bags] end)
    )
  end

  def find_all_outer_bags(bags, bag_name) do
    outer_bags = Map.get(bags, bag_name).contained_in
    find_outer_bags(outer_bags, [], bags)
  end

  def find_all_inner_bags(bags, bag_name) do
    inner_bags = Map.get(bags, bag_name).contains
    Enum.reduce(inner_bags, 0, &find_inner_bags(&1, &2, bags))
  end

  def find_inner_bags({inner_bag, count}, acc, bags, multiplier \\ 1) do
    inner_bags = Map.get(bags, inner_bag).contains
    multiplier = multiplier * count
    acc + multiplier + Enum.reduce(inner_bags, 0, &find_inner_bags(&1, &2, bags, multiplier))
  end


  def find_outer_bags([], acc, bags), do: Enum.uniq(acc)

  def find_outer_bags(bag_names, acc, bags) do
    acc =
      acc
      |> Enum.concat(bag_names)
      |> Enum.uniq()

    outer_bags =
      bag_names
      |> Enum.map(&Map.get(bags, &1).contained_in)
      |> List.flatten()

    find_outer_bags(outer_bags, acc, bags)
  end
end
