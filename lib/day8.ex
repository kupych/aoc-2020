defmodule Aoc2020.Day8 do
  @moduledoc """
  Solutions for Day 8.
  """
  @behaviour Aoc2020.Day

  alias Aoc2020.{BootCode, Day}

  @impl Day
  def day(), do: 8

  @impl Day
  def a(instructions) do
    {_, acc} = BootCode.run(instructions)
    acc
  end

  @impl Day
  def b(commands) do
    length = 0..(Enum.count(commands) - 1)

    Enum.reduce_while(length, 0, fn index, _ ->
      case Enum.at(commands, index) do
        {command, value} when command in [:nop, :jmp] ->
          command = if command == :nop, do: :jmp, else: :nop
          commands = List.replace_at(commands, index, {command, value})
          case BootCode.run(commands) do
            {:done, acc} -> {:halt, acc}
            {:looped, acc} -> {:cont, acc}
          end

        _ ->
          {:cont, 0}
      end
    end)
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&BootCode.parse_instruction/1)
    end
  end
end
