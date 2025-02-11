defmodule Dallas do
  @moduledoc """
  Documentation for `Dallas`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dallas.hello()
      :tralala

  """
  def get_monitored_application() do
    if Mix.env() == :test do
      :dallas
    else
      Application.get_env(:dallas, :monitor_application)
    end
  end
end
