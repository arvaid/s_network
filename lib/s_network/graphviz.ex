defmodule SNetwork.Graphviz do
  alias Graphvix.Graph

  def create(network) do
    Graph.new()
    |> generate(network.neurons, nil)
    |> Graph.compile("network.png")
  end

  defp generate(graph, [], _), do: graph

  defp generate(graph, [n | ns], parent_id) do
    {graph, vertex_id} = Graph.add_vertex(graph, n.label)

    case parent_id do
      nil ->
        generate(graph, ns, vertex_id)

      _ ->
        graph = Graph.add_edge(graph, parent_id, vertex_id)
        generate(graph, ns, vertex_id)
    end
  end
end
