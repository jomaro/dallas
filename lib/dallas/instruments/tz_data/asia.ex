defmodule Dallas.Instrument.TzData.Asia do

  use Dallas.Instrument

  alias Dallas.Measurement
  alias Dallas.Helpers.TableFormatter

  @probability 6

  def measure do
    timezones =
      Tzdata.canonical_zone_list()
      |> Enum.filter(&String.starts_with?(&1, "Asia"))


    timezones
    |> Enum.map(fn path ->
      %Measurement{
        path: "TzData/" <> path,
        level: get_level(path),
        value: hashsum(path),
        detail: TableFormatter.format_list(timezones),
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
