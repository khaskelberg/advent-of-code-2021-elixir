defmodule AdventOfCode.Day03 do
  def part1(args) do
    input = prepare_input(args)
    half = div(length(input), 2)
    number_length = input |> List.first() |> tuple_size()

    gamma_list =
      for pos <- 0..(number_length - 1) do
        zero_count = Enum.count(input, &(elem(&1, pos) == ?0))
        if zero_count > half, do: ?0, else: ?1
      end

    gamma = List.to_integer(gamma_list, 2)
    mask = Bitwise.bsl(1, number_length) - 1
    eps = Bitwise.bxor(mask, gamma)
    eps * gamma
  end

  def part2(args) do
    input = prepare_input(args)
    oxyg = bit_criteria(input, 0, &>=/2)
    co2 = bit_criteria(input, 0, &</2)
    oxyg * co2
  end

  def tuple_to_number(tuple) do
    tuple
    |> Tuple.to_list()
    |> List.to_integer(2)
  end

  def bit_criteria([number], _, _) do
    tuple_to_number(number)
  end

  def bit_criteria(numbers, pos, cmp) do
    zero_count = Enum.count(numbers, &(elem(&1, pos) == ?0))
    one_count = length(numbers) - zero_count
    keep = if cmp.(one_count, zero_count), do: ?1, else: ?0
    keep_numbers = Enum.filter(numbers, &(elem(&1, pos) == keep))
    bit_criteria(keep_numbers, pos + 1, cmp)
  end

  def prepare_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&string_to_tuple/1)
  end

  def string_to_tuple(str) do
    str
    |> String.to_charlist()
    |> List.to_tuple()
  end
end
