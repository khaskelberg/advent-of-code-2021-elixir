defmodule AdventOfCode.Day12 do
  def part1(args) do
    graph = parse_input(args)
    traverse_graph(graph, &can_visit_p1?/2)
  end

  def part2(args) do
    graph = parse_input(args)
    traverse_graph(graph, &can_visit_p2?/2)
  end

  def traverse_graph(graph, can_visit?) do
    traverse_graph(graph, "start", [], can_visit?)
  end

  def traverse_graph(_graph, "end", _walked, _can_visit?), do: 1

  def traverse_graph(graph, edge, walked, can_visit?) do
    walked = if downcase?(edge), do: [edge | walked], else: walked

    graph
    |> :digraph.out_neighbours(edge)
    |> Enum.filter(&can_visit?.(&1, walked))
    |> Enum.map(&traverse_graph(graph, &1, walked, can_visit?))
    |> Enum.sum()
  end

  # Part 1. Allowed only to visit every small cave once
  defp can_visit_p1?(edge, walked), do: edge not in walked

  # Part 2. Allowed to visit single small cave twice
  defp can_visit_p2?("start", _walked), do: false

  defp can_visit_p2?(edge, walked) do
    edge not in walked || length(Enum.uniq(walked)) == length(walked)
  end

  defp downcase?(str) do
    String.downcase(str) == str
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.reduce(:digraph.new(), fn [e1, e2], graph ->
      :digraph.add_vertex(graph, e1)
      :digraph.add_vertex(graph, e2)
      :digraph.add_edge(graph, e1, e2)
      :digraph.add_edge(graph, e2, e1)
      graph
    end)
  end
end
