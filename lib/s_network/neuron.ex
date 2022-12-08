defmodule SNetwork.Neuron do
  alias SNetwork.Neuron
  use GenServer

  defstruct receives_from: [],
            sends_to: [],
            func: nil,
            parent_pid: 0,
            label: "",
            pid: nil,
            id: nil

  ## GenServer callbacks

  @impl true
  def init(parent: parent, label: label) do
    {:ok,
     %__MODULE__{
       id: make_ref(),
       pid: self(),
       parent_pid: parent,
       label: label
     }}
  end

  @impl true
  def handle_cast({:input, data}, state) do
    output = state.func.(data)

    case length(state.sends_to) do
      0 ->
        send(state.parent_pid, {:output, output})

      _ ->
        Enum.each(state.sends_to, fn x -> send_input(x, output) end)
    end

    {:noreply, state}
  end

  @impl true
  def handle_call({:add_input, pid}, _from, state) do
    {
      :reply,
      :ok,
      %Neuron{state | receives_from: [pid | state.receives_from]}
    }
  end

  @impl true
  def handle_call({:remove_input, pid}, _from, state) do
    {
      :reply,
      :ok,
      %Neuron{state | receives_from: Enum.reject(state.receives_from, &(&1 == pid))}
    }
  end

  @impl true
  def handle_call({:add_output, pid}, _from, state) do
    {
      :reply,
      :ok,
      %Neuron{state | sends_to: [pid | state.sends_to]}
    }
  end

  @impl true
  def handle_call({:remove_output, pid}, _from, state) do
    {
      :reply,
      :ok,
      %Neuron{state | sends_to: Enum.reject(state.sends_to, &(&1 == pid))}
    }
  end

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, self(), opts)
  end

  def send_input(server, data) do
    GenServer.cast(server, {:input, data})
  end

  def add_input(server, pid) do
    GenServer.call(server, {:add_input, pid})

    receive do
      :ok -> :ok
      _ -> :error
    end
  end

  def remove_input(server, pid) do
    GenServer.call(server, {:remove_input, pid})

    receive do
      :ok -> :ok
      _ -> :error
    end
  end

  def add_output(server, pid) do
    GenServer.call(server, {:add_output, pid})

    receive do
      :ok -> :ok
      _ -> :error
    end
  end

  def remove_output(server, pid) do
    GenServer.call(server, {:remove_output, pid})

    receive do
      :ok -> :ok
      _ -> :error
    end
  end
end
