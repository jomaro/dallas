defmodule Example.Instruments.Operations do
  use Dallas.Instrument, queue: :default

  alias Dallas.Measurement
  alias Dallas.Helpers.TableFormatter

  @clients %{
    "Saturn Connections" => 6,
    "Earth Metals" => 25,
    "Mercury Eletronics" => 204,
    "Venus Clothing" => 0,
  }

  def measure do
    :rand.seed(:exsss, {1406, 314159, 271828})
    
    @clients
    |> Enum.map(fn {client, errors} ->
      %Measurement{
        path: "Operations/DuplicatedTokens/#{client}",
        level: get_level(errors),
        value: errors,
        detail: TableFormatter.format_list(gen_random_list(errors), 6),
      }
    end)
  end

  defp get_level(0), do: :ok
  defp get_level(_), do: :error

  defp gen_random_list(0), do: []
  defp gen_random_list(errors) do
    0..(errors-1)
    |> Enum.map(fn _ -> :rand.uniform(1_000_000_000) end)
  end

end
