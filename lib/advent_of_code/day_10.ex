defmodule AdventOfCode.Day10 do
  @illegal_points %{
    ?) => 3,
    ?] => 57,
    ?} => 1197,
    ?> => 25137
  }

  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn
      {:corrupted, char} -> @illegal_points[char]
      _ -> 0
    end)
    |> Enum.sum()
  end

  @incomplete_points %{
    ?) => 1,
    ?] => 2,
    ?} => 3,
    ?> => 4
  }

  def part2(args) do
    scores =
      args
      |> parse_input()
      |> Enum.map(&parse_line/1)
      |> Enum.filter(fn res -> match?({:incomplete, _}, res) end)
      |> Enum.map(fn {_, to_complete} -> autocomplete_score(to_complete) end)
      |> Enum.sort()

    Enum.at(scores, div(length(scores), 2))
  end

  defp autocomplete_score(to_complete) do
    Enum.reduce(to_complete, 0, fn char, score ->
      score * 5 + @incomplete_points[char]
    end)
  end

  defp parse_line(line) do
    parse_line(line, [])
  end

  defp parse_line(<<>>, []), do: :ok
  defp parse_line(<<>>, stack), do: {:incomplete, stack}
  defp parse_line(<<?{, rest::binary>>, stack), do: parse_line(rest, [?} | stack])
  defp parse_line(<<?(, rest::binary>>, stack), do: parse_line(rest, [?) | stack])
  defp parse_line(<<?[, rest::binary>>, stack), do: parse_line(rest, [?] | stack])
  defp parse_line(<<?<, rest::binary>>, stack), do: parse_line(rest, [?> | stack])

  defp parse_line(<<char, rest::binary>>, [char | stack]), do: parse_line(rest, stack)
  defp parse_line(<<char, _rest::binary>>, _stack), do: {:corrupted, char}

  defp parse_input(input) do
    String.split(input, "\n", trim: true)
  end
end
