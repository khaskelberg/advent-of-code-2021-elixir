defmodule AdventOfCode.Day06 do
  def part1({timers, days}) do
    frequencies =
      timers
      |> parse_timers()
      |> Enum.frequencies()
      |> Enum.reduce(List.duplicate(0, 9), fn {time, count}, freq ->
        List.update_at(freq, time, &(&1 + count))
      end)

    Enum.reduce(1..days, frequencies, fn _, [zeros | counts] ->
      List.update_at(counts, 6, fn fishes -> zeros + fishes end) ++ [zeros]
    end)
    |> Enum.sum()
  end

  def part2({timers, days}) do
    part1({timers, days})
  end

  defp parse_timers(timers) do
    timers
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
