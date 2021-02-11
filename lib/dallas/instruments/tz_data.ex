defmodule Dallas.Instrument.TzData do

  alias Dallas.Measurement
  alias Dallas.Helpers.TableFormatter

  @probability 6

  def measure do
    detail_example = get_dummy_table_for_detail_example()

    Tzdata.canonical_zone_list()
    |> Enum.map(fn path ->
      %Measurement{
        path: path,
        level: get_level(path),
        value: hashsum(path),
        detail: TableFormatter.format_list(detail_example),
      }
    end)
  end

  def get_dummy_table_for_detail_example() do
    tz_files = Tzdata.zone_lists_grouped

    [
      tz_files.africa,
      tz_files.asia,
      tz_files.australasia |> Enum.map(&String.replace(&1, "Pacific/", "Pacific/")),
      tz_files.europe,
      tz_files.northamerica,
      tz_files.southamerica,
    ]
    |> Enum.zip()
    |> Enum.map(fn line -> line |> Tuple.to_list end)
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
