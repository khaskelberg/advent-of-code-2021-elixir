defmodule AdventOfCode.Day11 do
  def part1({input, steps}) do
    grid = parse_input(input)

    {_, flashes} =
      Enum.reduce(1..steps, {grid, 0}, fn _, {grid, flashes} ->
        {grid, step_flashes} = do_step(grid)
        {grid, flashes + step_flashes}
      end)

    flashes
  end

  def do_step(grid) do
    grid = Enum.map(grid, &(&1 + 1))

    {flash_pos, _} =
      Enum.reduce(grid, {[], 0}, fn
        energy, {positions, index} when energy == 10 ->
          {[index | positions], index + 1}

        _, {positions, index} ->
          {positions, index + 1}
      end)

    {grid, step_flashes} = flash(List.to_tuple(grid), flash_pos, 0)

    grid =
      Enum.map(grid, fn
        energy when energy == nil -> 0
        energy -> energy
      end)

    {grid, step_flashes}
  end

  def flash(grid, [], flashes) do
    {Tuple.to_list(grid), flashes}
  end

  def flash(grid, [pos | stack], flashes) when elem(grid, pos) == nil do
    flash(grid, stack, flashes)
  end

  def flash(grid, [pos | stack], flashes) when elem(grid, pos) == 10 do
    grid = put_elem(grid, pos, nil)

    # We have to do this to account for numbers on left and right step
    offsets =
      case rem(pos, 10) do
        0 -> [1, -10, -9, 10, 11]
        9 -> [-1, -10, -11, 10, 9]
        _ -> [1, -1, 9, 10, 11, -9, -10, -11]
      end

    new_positions =
      offsets
      |> Enum.map(&(&1 + pos))
      |> Enum.filter(&(&1 in 0..99))

    flash(grid, new_positions ++ stack, flashes + 1)
  end

  def flash(grid, [pos | stack], flashes) when elem(grid, pos) == 9 do
    grid = put_elem(grid, pos, 10)
    flash(grid, [pos | stack], flashes)
  end

  def flash(grid, [pos | stack], flashes) do
    energy = elem(grid, pos)
    grid = put_elem(grid, pos, energy + 1)
    flash(grid, stack, flashes)
  end

  def part2(input) do
    grid = parse_input(input)

    step(grid, 0)
  end

  @all_flash List.duplicate(0, 100)

  def step(@all_flash, step) do
    step
  end

  def step(grid, step) do
    {grid, _} = do_step(grid)
    step(grid, step + 1)
  end

  # We store grid as a tuple
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> List.flatten()
    |> Enum.map(&(&1 - ?0))
  end
end
