defmodule Aoc2020.BootCode do
  @moduledoc """
  Interpreter/parser for the boot code used in Day 8.
  """

  def parse_instruction("acc " <> number) do
    {:acc, String.to_integer(number)}
  end

  def parse_instruction("jmp " <> number) do
    {:jmp, String.to_integer(number)}
  end

  def parse_instruction("nop " <> number) do
    {:nop, String.to_integer(number)}
  end

  def run(commands) do
    run_command(commands)
  end

  def run_command(commands, index, acc, _, _) when index < 0 or index > length(commands) do
    {:err, index, :out_of_range}
  end

  def run_command(commands, index \\ 0, acc \\ 0, history \\ [])
  def run_command(commands, index, acc, history) do
    {command, value} = Enum.at(commands, index)
    history = [index | history]

    {acc, index} = apply(__MODULE__, command, [value, acc, index])

    cond do
      Enum.member?(history, index) -> {:looped, acc}
      index == Enum.count(commands) -> {:done, acc}
      true -> run_command(commands, index, acc, history)
    end
  end

  def nop(_, acc, index), do: {acc, index + 1}

  def acc(value, acc, index), do: {acc + value, index + 1}

  def jmp(value, acc, index), do: {acc, index + value}
end
