defmodule Dallas.Instrument.TzData do

  alias Dallas.Measurement

  @probability 6

  def measure do
    tz_files = Tzdata.zone_lists_grouped

    Tzdata.canonical_zone_list()
    |> Enum.map(fn path ->
      %Measurement{
        path: path,
        level: get_level(path),
        value: hashsum(path),
        detail: detail(tz_files),
      }
    end)
  end

  def detail(tz_files) do
    [
      tz_files.africa,
      tz_files.asia,
      tz_files.australasia,
      tz_files.europe,
      tz_files.southamerica
    ]
    |> Enum.zip()
    |> Enum.map(fn line -> line |> Tuple.to_list |> Enum.join(" ") end)
    |> Enum.join("\n")
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
