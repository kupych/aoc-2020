defmodule Aoc2020.Day12 do
  @moduledoc """
  Solutions for Day 12.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.Day

  @impl Day
  def day(), do: 12

  @impl Day
  def a(movements) do
    {x, y, _} =
      movements
      |> Enum.reduce({0, 0, 90}, &move_a/2)
      |> IO.inspect()

    [x, y]
    |> Enum.map(&Kernel.abs/1)
    |> Enum.sum()
  end

  @impl Day
  def b(movements) do
    {x, y, _, _} =
      movements
      |> Enum.reduce({0, 0, 10, 1}, &move_b/2)
      |> IO.inspect()

    [x, y]
    |> Enum.map(&Kernel.abs/1)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(fn <<dir::size(8), amount::binary>> -> {<<dir>>, String.to_integer(amount)} end)
    end
  end

  def move_a({"N", amount}, {x, y, dir}) do
    {x, y + amount, dir}
  end

  def move_a({"E", amount}, {x, y, dir}) do
    {x + amount, y, dir}
  end

  def move_a({"S", amount}, {x, y, dir}) do
    {x, y - amount, dir}
  end

  def move_a({"W", amount}, {x, y, dir}) do
    {x - amount, y, dir}
  end

  def move_a({"L", amount}, {x, y, dir}) do
    {x, y, Integer.mod(dir - amount, 360)}
  end

  def move_a({"R", amount}, {x, y, dir}) do
    {x, y, Integer.mod(dir + amount, 360)}
  end

  def move_a({"F", amount}, {x, y, dir}) do
    x_diff = amount * sin_degrees(dir)
    y_diff = amount * cos_degrees(dir)
    {x + x_diff, y + y_diff, dir}
  end

  def move_a(_, _, acc) do
    acc
  end

  def move_b({"N", amount}, {x, y, way_x, way_y}) do
    {x, y, way_x, way_y + amount}
  end

  def move_b({"E", amount}, {x, y, way_x, way_y}) do
    {x, y, way_x + amount, way_y}
  end

  def move_b({"S", amount}, {x, y, way_x, way_y}) do
    {x, y, way_x, way_y - amount}
  end

  def move_b({"W", amount}, {x, y, way_x, way_y}) do
    {x, y, way_x - amount, way_y}
  end

  def move_b({"F", amount}, {x, y, way_x, way_y}) do
    {x + amount * way_x, y + amount * way_y, way_x, way_y}
  end

  def move_b({_, 180}, {x, y, way_x, way_y}) do
    {x, y, -way_x, -way_y}
  end

  def move_b({"R", 90}, {x, y, way_x, way_y}) do
    {x, y, way_y, -way_x}
  end

  def move_b({"L", 270}, {x, y, way_x, way_y}) do
    {x, y, way_y, -way_x}
  end
  def move_b({"R", 270}, {x, y, way_x, way_y}) do
    {x, y, -way_y, way_x}
  end

  def move_b({"L", 90}, {x, y, way_x, way_y}) do
    {x, y, -way_y, way_x}
  end

  def sin_degrees(degrees) do
    :math.sin(degrees * :math.pi() / 180) |> trunc()
  end

  def cos_degrees(degrees) do
    :math.cos(degrees * :math.pi() / 180) |> trunc()
  end
end
