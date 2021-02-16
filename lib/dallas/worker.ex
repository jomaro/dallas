defmodule Dallas.Worker do

  alias Dallas.ResultSet
  alias Dallas.Instrument

  @n_workers 4

  def run() do
    Instrument.get_whitelisted_instruments(:general)
    |> Task.async_stream(&run_instrument/1, max_concurrency: @n_workers, timeout: 40*60*1_000)
    |> Stream.run

    :ok
  end

  defp run_instrument(instrument) do
    instrument.measure()
      |> List.wrap()
      |> Enum.map(fn measurement ->
        %{
          measurement
          | instrument: instrument,
            execution_date: measurement.execution_date || DateTime.utc_now(),
            actions: [{"go to source", get_source_link(instrument)} | measurement.actions],
        }
      end)
      |> ResultSet.update()
  end

  defp get_source_link(module) do
    module
    |> Atom.to_string()
    |> String.replace(".", "/")
    |> Macro.underscore()
  end

end
