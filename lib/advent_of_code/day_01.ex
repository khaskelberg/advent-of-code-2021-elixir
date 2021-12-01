defmodule AdventOfCode.Day01 do
  def part1(args) do
    {result, _} =
      args
      |> prepare_input()
      |> Enum.reduce({0, nil}, fn
        x, {0, nil} -> {0, x}
        x, {res, prev} when x > prev -> {res + 1, x}
        x, {res, _} -> {res, x}
      end)

    result
  end

  def part2(args) do
    {result, _} =
      args
      |> prepare_input()
      |> Enum.reduce({0, {nil, nil, nil}}, fn
        x, {0, {p1, p2, p3}} when p1 == nil or p2 == nil or p3 == nil -> {0, {x, p1, p2}}
        x, {res, {p1, p2, p3}} when x > p3 -> {res + 1, {x, p1, p2}}
        x, {res, {p1, p2, _p3}} -> {res, {x, p1, p2}}
      end)

    result
  end

  defp prepare_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
