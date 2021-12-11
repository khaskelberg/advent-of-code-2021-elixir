defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  @input """
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  """

  @tag :skip
  test "part1" do
    input = @input
    result = part1(input)

    assert result == 15
  end

  @tag :skip
  test "part2" do
    input = @input
    result = part2(input)

    assert result == 1134
  end
end
