defmodule AdventOfCode.Day05 do
  def part1(args) do
    lines = prepare_input(args)

    grid =
      Enum.reduce(lines, %{}, fn line, grid ->
        dots =
          case line do
            [x, y1, x, y2] -> Enum.map(y1..y2, &{x, &1})
            [x1, y, x2, y] -> Enum.map(x1..x2, &{&1, y})
            _ -> []
          end

        Enum.reduce(dots, grid, fn dot, grid ->
          Map.update(grid, dot, 1, &(&1 + 1))
        end)
      end)

    Enum.count(grid, fn {_, c} -> c > 1 end)
  end

  def part2(args) do
    lines = prepare_input(args)

    grid =
      Enum.reduce(lines, %{}, fn line, grid ->
        dots =
          case line do
            [x, y1, x, y2] ->
              Enum.map(y1..y2, &{x, &1})

            [x1, y, x2, y] ->
              Enum.map(x1..x2, &{&1, y})

            [x1, y1, x2, y2] ->
              Enum.zip(x1..x2, y1..y2)
          end

        Enum.reduce(dots, grid, fn dot, grid ->
          Map.update(grid, dot, 1, &(&1 + 1))
        end)
      end)

    Enum.count(grid, fn {_, c} -> c > 1 end)
  end

  def prepare_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([",", " -> "], trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
