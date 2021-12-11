defmodule AdventOfCode.Day09 do
  def part1(args) do
    args
    |> parse_input()
    |> lowest_points()
    |> Enum.reduce(0, fn {_, height}, sum -> sum + height + 1 end)
  end

  defp lowest_points(grid) do
    Enum.filter(grid, fn {{row, col}, height} ->
      offsets = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
      Enum.all?(offsets, fn {x, y} -> height < grid[{row + x, col + y}] end)
    end)
  end

  def part2(args) do
    grid = parse_input(args)

    lowest_points = lowest_points(grid)

    basins =
      Enum.reduce(grid, %{}, fn {point, height}, basins ->
        Map.put(basins, point, {height, nil})
      end)

    {q, basins, _} =
      Enum.reduce(lowest_points, {:queue.new(), basins, 0}, fn {point, height},
                                                               {q, basins, index} ->
        {:queue.in(point, q), Map.put(basins, point, {height, index}), index + 1}
      end)

    basins = mark_basins(:queue.out(q), basins)

    basins
    |> Enum.group_by(fn {_, {_, index}} -> index end)
    |> Map.delete(nil)
    |> Enum.map(fn {_, list} -> length(list) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def mark_basins({:empty, _}, basins) do
    basins
  end

  def mark_basins({{:value, point}, queue}, basins) do
    {row, col} = point
    {height, basin_index} = Map.get(basins, point)

    offsets = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

    {queue, basins} =
      Enum.reduce(offsets, {queue, basins}, fn {offset_x, offset_y}, {q, basins} ->
        new_point = {row + offset_x, col + offset_y}

        case Map.get(basins, new_point) do
          {9, _} ->
            {q, basins}

          {nil, _} ->
            {q, basins}

          {h, nil} when h > height ->
            q = :queue.in(new_point, q)
            basins = Map.put(basins, new_point, {h, basin_index})
            {q, basins}

          _ ->
            {q, basins}
        end
      end)

    mark_basins(:queue.out(queue), basins)
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    for {line, row} <- Enum.with_index(lines),
        {height, col} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{row, col}, height - ?0}
    end
  end
end
