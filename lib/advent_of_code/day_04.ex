defmodule AdventOfCode.Day04 do
  defmodule Board do
    defstruct numbers: %{}, cells: Tuple.duplicate(false, 25)

    def new(numbers) when is_map(numbers) do
      %Board{numbers: numbers}
    end

    def mark(%Board{numbers: numbers, cells: cells} = board, number) do
      case Map.get(numbers, number, nil) do
        nil -> board
        index -> %{board | cells: put_elem(cells, index, true)}
      end
    end

    def won?(%Board{cells: cells}) do
      row_won?(cells) or col_won?(cells)
    end

    defp row_won?(cells) do
      Enum.any?(0..4, fn row ->
        Enum.all?(0..4, fn col -> elem(cells, row * 5 + col) end)
      end)
    end

    defp col_won?(cells) do
      Enum.any?(0..4, fn col ->
        Enum.all?(0..4, fn row -> elem(cells, col + row * 5) end)
      end)
    end

    def unmarked_sum(%Board{numbers: numbers, cells: cells}) do
      Enum.reduce(numbers, 0, fn {number, index}, sum ->
        if not elem(cells, index) do
          sum + number
        else
          sum
        end
      end)
    end
  end

  def part1(args) do
    {numbers, boards} = prepare_input(args)

    {number, board} =
      Enum.reduce_while(numbers, boards, fn number, boards ->
        boards = Enum.map(boards, &Board.mark(&1, number))
        winning_board = Enum.find(boards, &Board.won?/1)

        case winning_board do
          nil -> {:cont, boards}
          board -> {:halt, {number, board}}
        end
      end)

    number * Board.unmarked_sum(board)
  end

  def part2(args) do
    {numbers, boards} = prepare_input(args)

    {number, board} =
      Enum.reduce_while(numbers, boards, fn number, boards ->
        boards = Enum.map(boards, &Board.mark(&1, number))

        case Enum.reject(boards, &Board.won?/1) do
          [] -> {:halt, {number, List.first(boards)}}
          boards -> {:cont, boards}
        end
      end)

    number * Board.unmarked_sum(board)
  end

  def prepare_input(input) do
    [numbers | board_strs] = String.split(input, "\n", trim: true)
    numbers = numstring_to_list(numbers, ",")

    boards =
      board_strs
      |> Enum.map(&numstring_to_list(&1, " "))
      |> Enum.chunk_every(5)
      |> Enum.map(&List.flatten/1)
      |> Enum.map(&boardlist_to_board/1)

    {numbers, boards}
  end

  defp boardlist_to_board(boardlist) do
    boardlist
    |> Enum.with_index()
    |> Map.new()
    |> Board.new()
  end

  defp numstring_to_list(str, sep) do
    str
    |> String.split(sep, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
