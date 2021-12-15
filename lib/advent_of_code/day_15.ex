defmodule AdventOfCode.Day15 do
  def part1(args) do
    matrix = parse_input(args)
    shortest_path(matrix)
  end

  def shortest_path(matrix) do
    paths =
      matrix
      |> Enum.into(%{}, fn {coord, _} -> {coord, nil} end)
      |> Map.put({0, 0}, 0)

    q = :queue.new()
    q = :queue.in({0, 0}, q)
    paths = shortest_path(:queue.out(q), paths, matrix)
    {_, shortest_path} = Enum.max_by(paths, fn {{x, y}, _} -> x * y end)
    shortest_path
  end

  defp shortest_path({:empty, _}, paths, _matrix), do: paths

  defp shortest_path({{:value, {x, y} = coord}, queue}, paths, matrix) do
    neighboors = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    risk_current = Map.get(paths, coord)

    {paths, queue} =
      Enum.reduce(neighboors, {paths, queue}, fn neighboor, {paths, q} ->
        cost = Map.get(matrix, neighboor)
        risk_neighboor = Map.get(paths, neighboor)

        case cost do
          nil ->
            {paths, q}

          c when risk_current + c < risk_neighboor ->
            {Map.put(paths, neighboor, risk_current + c), :queue.in(neighboor, q)}

          _ ->
            {paths, q}
        end
      end)

    shortest_path(:queue.out(queue), paths, matrix)
  end

  def part2(args) do
    matrix = parse_input(args)

    size =
      matrix
      |> map_size()
      |> :math.sqrt()
      |> trunc()

    matrix
    |> Enum.reduce(%{}, fn {{x, y}, risk}, full_matrix ->
      for i <- 0..4,
          j <- 0..4,
          into: full_matrix do
        new_risk = risk + i + j
        new_risk = if new_risk >= 10, do: rem(new_risk, 9), else: new_risk
        {{size * i + x, size * j + y}, new_risk}
      end
    end)
    |> shortest_path()
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    for {line, x} <- Enum.with_index(lines),
        {risk, y} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{x, y}, risk - ?0}
    end
  end
end
