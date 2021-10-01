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
    IO.inspect(buses)
    
    {time, bus_id} = buses
    |> Enum.map(&nearest_departure(&1, timestamp))
    |> Enum.sort()
    |> IO.inspect
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
    |> IO.inspect
    |> pingus
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

  def pingus([{bus, 0} | rest]) do
    pingus(rest, bus, bus)
  end

  def pingus([], total, _) do
    total
  end


  def pingus([{bus, offset} = head | rest], total, mult) do
    case Kernel.rem((total + offset), bus) do
      0 -> IO.inspect(total)
        pingus(rest, total, total)
      _ -> 
        IO.inspect({bus, offset, total}, label: :not_yet)
        pingus([head | rest], total + mult, mult)
    end
  end

end
