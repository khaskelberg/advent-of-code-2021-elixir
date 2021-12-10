defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  @timers "3,4,3,1,2"

  @tag :skip
  test "part1" do
    result = part1({@timers, 80})

    assert result == 5934
  end

  @tag :skip
  test "part2" do
    result = part2({@timers, 256})

    assert result == 26_984_457_539
  end
end
