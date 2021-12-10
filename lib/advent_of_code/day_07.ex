defmodule AdventOfCode.Day07 do
  def part1(args) do
    positions = parse_input(args)
    median = median(positions)

    positions
    |> Enum.map(fn pos -> abs(pos - median) end)
    |> Enum.sum()
  end

  def part2(args) do
    positions = parse_input(args)
    {min, max} = Enum.min_max(positions)

    min..max
    |> Enum.map(fn pos ->
      Enum.reduce(positions, 0, fn crab_pos, fuel ->
        dist = abs(pos - crab_pos)
        fuel + div((1 + dist) * dist, 2)
      end)
    end)
    |> Enum.min()
  end

  defp median(list) do
    center = div(length(list), 2)

    list
    |> Enum.sort()
    |> Enum.at(center)
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
