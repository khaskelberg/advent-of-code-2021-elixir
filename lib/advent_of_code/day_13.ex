defmodule AdventOfCode.Day13 do
  def part1(args) do
    {dots, [instruction | _]} = parse_input(args)

    dots
    |> fold(instruction)
    |> Enum.count()
  end

  def part2(args) do
    {dots, instructions} = parse_input(args)

    instructions
    |> Enum.reduce(dots, &fold(&2, &1))
    |> print_grid
  end

  def fold(dots, {:x, coord}) do
    Enum.reduce(dots, MapSet.new(), fn
      {^coord, _}, dots -> dots
      {x, y}, dots -> MapSet.put(dots, {abs(coord - x) - 1, y})
    end)
  end

  def fold(dots, {:y, coord}) do
    Enum.reduce(dots, MapSet.new(), fn
      {_, ^coord}, dots -> dots
      {x, y}, dots -> MapSet.put(dots, {x, abs(coord - y) - 1})
    end)
  end

  def print_grid(dots) do
    {max_x, max_y} =
      Enum.reduce(dots, {0, 0}, fn {x, y}, {max_x, max_y} ->
        max_x = if x > max_x, do: x, else: max_x
        max_y = if y > max_y, do: y, else: max_y
        {max_x, max_y}
      end)

    grid =
      Enum.map_join(0..max_y, "\n", fn y ->
        Enum.map_join(0..max_x, fn x ->
          # Because we fold down and right we have to mirror every dot
          if MapSet.member?(dots, {max_x - x, max_y - y}) do
            "#"
          else
            "."
          end
        end)
      end)

    IO.puts("\n" <> grid <> "\n")
    grid
  end

  @spec parse_input(binary) :: {any, list}
  def parse_input(input) do
    [dots, instructions] = String.split(input, "\n\n", trim: true)

    instructions =
      instructions
      |> String.split("\n", trim: true)
      |> Enum.map(&extract_fold/1)

    dots =
      dots
      |> String.split("\n", trim: true)
      |> Enum.reduce(MapSet.new(), fn dot, grid ->
        [x, y] =
          dot
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer/1)

        MapSet.put(grid, {x, y})
      end)

    {dots, instructions}
  end

  defp extract_fold("fold along x=" <> coord) do
    {:x, String.to_integer(coord)}
  end

  defp extract_fold("fold along y=" <> coord) do
    {:y, String.to_integer(coord)}
  end
end
