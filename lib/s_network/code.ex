defmodule Neuron.Code do
  @moduledoc """
  Module for parsing and evaluating code to execute.
  """

  @doc """
  Evaluate a piece of code given as a string.
  """
  def eval({:erlang, expression}) do
    with expression = String.to_charlist(expression),
         {:ok, tokens, _} = :erl_scan.string(expression),
         {:ok, parsed} = :erl_parse.parse_exprs(tokens),
         {:value, result, _} = :erl_eval.exprs(parsed, []) do
      {:ok, result}
    else
      err -> err
    end
  end

  def eval({:elixir, expression}) do
    try do
      {function, _} = Code.eval_string(expression)
      function
    rescue
      _e in CompileError -> {:error, "invalid expression"}
    end
  end

  def eval(expression), do: eval({:elixir, expression})
end
