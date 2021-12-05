defmodule Aoc2020.Day13 do
  @moduledoc """
  Solutions for Day 13.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 13

  @impl Day
  def a({timestamp, buses}) do
    buses = Enum.filter(buses, &is_integer/1)
    
    {time, bus_id} = buses
    |> Enum.map(&nearest_departure(&1, timestamp))
    |> Enum.sort()
    |> hd()

    bus_id * time
  end

  @impl Day
  def b({_, buses}) do
    buses
    |> Enum.with_index
    |> Enum.reject(fn 
      {"x", _} -> true
      _ -> false
    end)
    |> IO.inspect()
    |> check_window()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      [timestamp, buses] =
        file
        |> String.split("\n", trim: true)

      buses =
        buses
        |> String.split(",")
        |> Enum.map(fn
          "x" -> "x"
          bus -> String.to_integer(bus)
        end)

      {String.to_integer(timestamp), buses}
    end
  end

  def nearest_departure(bus_id, timestamp) do
    nearest_time = timestamp
    |> Kernel.div(bus_id)
    |> Kernel.+(1)
    |> Kernel.*(bus_id)
    |> Kernel.-(timestamp)

    {nearest_time, bus_id}
  end

  def check_window([{bus, 0} | rest]) do
    check_window(rest, bus, bus)
  end

  def check_window([], total, _) do
    total
  end


  def check_window([{bus, offset} = head | rest], total, mult) do
    case Kernel.rem((total + offset), bus) do
      0 -> IO.inspect(total)
        check_window(rest, total, mult * bus)
      _ -> 
        IO.inspect({bus, offset, total}, label: :not_yet)
        check_window([head | rest], total + mult, mult)
    end
  end

end
