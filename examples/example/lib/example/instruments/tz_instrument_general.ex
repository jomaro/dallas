defmodule Example.Instruments.TzInstrumentGeneral do
  use Dallas.Instrument

  alias Dallas.Measurement
  alias Dallas.Helpers.TableFormatter

  @probability 6

  # Example.Instruments.TzInstrument.measure() |> Dallas.ResultSet.update()

  def measure do
    timezones =
      Tzdata.canonical_zone_list()
      |> Enum.reject(&String.starts_with?(&1, "America"))

    timezones
    |> Enum.map(fn path ->
      %Measurement{
        path: "TzData/" <> path,
        level: get_level(path),
        value: hashsum(path),
        detail: TableFormatter.format_list(timezones, 6),
      }
    end)
  end

  defp get_level(path) do
    if 0 == rem(hashsum(path), @probability) do
      :error
    else
      :ok
    end
  end

  defp hashsum(path) do
    path
    |> to_charlist()
    |> Enum.sum
  end

end
