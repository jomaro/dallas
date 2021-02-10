defmodule Dallas.Worker do

  alias Dallas.ResultSet

  @instrument_list [
    Dallas.Instrument.TzData,
  ]

  def run() do
    for instrument <- @instrument_list do
      instrument.measure()
      |> List.wrap()
      |> Enum.map(fn measurement ->
        %{
          measurement
          | instrument: instrument,
            actions: [{"got to source", get_source_link(instrument)} | measurement.actions],
        }
      end)
      |> ResultSet.update()
    end

    :ok
  end

  defp get_source_link(module) do
    module
    |> Atom.to_string()
    |> String.replace(".", "/")
    |> Macro.underscore()
  end

end
