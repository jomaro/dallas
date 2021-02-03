defmodule Dallas.Instrument.TzData do

  alias Dallas.Measurement

  @probability 6

  def measure do
    Tzdata.canonical_zone_list()
    # |> Enum.flat_map(fn {file, tz_list} -> tz_list |> Enum.map(fn tz -> to_string(file) <> "/" <> tz end) end)
    |> Enum.map(fn path ->
      %Measurement{
        path: path,
        level: get_level(path),
        value: hashsum(path),
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
