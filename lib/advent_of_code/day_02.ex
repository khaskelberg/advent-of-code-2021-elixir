defmodule AdventOfCode.Day02 do
  def part1(args) do
    {hor, dep} =
      args
      |> prepare_input()
      |> Enum.reduce({0, 0}, fn
        {:forward, x}, {hor, dep} -> {hor + x, dep}
        {:down, x}, {hor, dep} -> {hor, dep + x}
        {:up, x}, {hor, dep} -> {hor, max(dep - x, 0)}
      end)

    hor * dep
  end

  def part2(args) do
    {hor, dep, _} =
      args
      |> prepare_input()
      |> Enum.reduce({0, 0, 0}, fn
        {:down, x}, {hor, dep, aim} -> {hor, dep, aim + x}
        {:up, x}, {hor, dep, aim} -> {hor, dep, aim - x}
        {:forward, x}, {hor, dep, aim} -> {hor + x, dep + aim * x, aim}
      end)

    hor * dep
  end

  def prepare_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_command/1)
  end

  def parse_command("forward " <> x), do: {:forward, String.to_integer(x)}
  def parse_command("up " <> x), do: {:up, String.to_integer(x)}
  def parse_command("down " <> x), do: {:down, String.to_integer(x)}
end
