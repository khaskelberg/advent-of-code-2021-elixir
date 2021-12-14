defmodule AdventOfCode.Day14 do
  def part1({input, steps}) do
    polymerize(input, steps)
  end

  def part2({input, steps}) do
    polymerize(input, steps)
  end

  def polymerize(input, steps) do
    {template, rules} = parse_input(input)

    # We need last character because it won't be counted in pairs
    last_char = String.last(template)
    pairs = template_to_pairs(template)

    {{_, min}, {_, max}} =
      1..steps
      |> Enum.reduce(pairs, fn _, pairs -> step(pairs, rules) end)
      |> Enum.reduce(%{last_char => 1}, fn {{a, _}, count}, counts ->
        Map.update(counts, a, count, &(&1 + count))
      end)
      |> Enum.min_max_by(fn {_, c} -> c end)

    max - min
  end

  defp template_to_pairs(template) do
    template
    |> String.split("", trim: true)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.frequencies()
  end

  defp step(pairs, rules) do
    Enum.reduce(pairs, %{}, fn {{a, b} = pair, count}, pairs ->
      elem = Map.get(rules, pair)

      pairs
      |> Map.update({a, elem}, count, &(count + &1))
      |> Map.update({elem, b}, count, &(count + &1))
    end)
  end

  defp parse_input(input) do
    [template, rules] = String.split(input, "\n\n", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.into(%{}, &parse_rule/1)

    {template, rules}
  end

  defp parse_rule(rule) do
    [pair, insertion] = String.split(rule, " -> ", trim: true)

    pair =
      pair
      |> String.split("", trim: true)
      |> List.to_tuple()

    {pair, insertion}
  end
end
