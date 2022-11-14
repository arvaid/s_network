defmodule SNetworkTest do
  use ExUnit.Case
  doctest SNetwork

  test "greets the world" do
    assert SNetwork.hello() == :world
  end
end
