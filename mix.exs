defmodule SNetwork.MixProject do
  use Mix.Project

  def project do
    [
      app: :s_network,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {SNetwork.Application, []}
    ]
  end

  defp deps do
    [
      {:graphvix, "~> 1.0.0"},
      {:stream_data, "~> 0.5"}
    ]
  end
end
