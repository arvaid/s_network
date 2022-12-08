defmodule SNetwork.Network do
  alias SNetwork.Network
  alias SNetwork.Neuron

  defstruct neurons: []

  def new(), do: %Network{}

  def add_neuron(network, label \\ "") do
    pid = Neuron.start_link(parent: self(), label: label)
    %Network{network | neurons: [pid | network.neurons]}
  end

  def remove_neuron(network, id) do
    %Network{network | neurons: Enum.reject(network.neurons, &(&1.id == id))}
  end

  def add_connection(network, from, to) do
    Neuron.add_output(from, to)
    Neuron.add_input(to, from)
    network
  end

  def remove_connection(network, from, to) do
    Neuron.remove_output(from, to)
    Neuron.remove_input(to, from)
    network
  end

  def send_input(network, input) do
    Stream.zip(input, inputs(network))
    |> Enum.each(fn {data, neuron} -> Neuron.send_input(neuron, data) end)
  end

  def inputs(network) do
    Enum.filter(network.neurons, fn n -> n.receives_from === [] end)
  end

  def outputs(network) do
    Enum.filter(network.neurons, fn n -> n.sends_to === [] end)
  end
end
