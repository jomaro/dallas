defmodule Dallas.Instrument.TzData.Others do

  use Dallas.Instrument

  alias Dallas.Measurement
  alias Dallas.Helpers.TableFormatter

  @non_generic_timezones ~w[
    Africa
    America
    Antarctica
    Asia
    Atlantic
    Australia
    Europe
    Indian
    Pacific
  ]

  @probability 6

  def measure do
    timezones =
      Tzdata.canonical_zone_list()
      |> Enum.reject(fn item -> item |> String.split("/") |> hd() |> Kernel.in(@non_generic_timezones) end)


    timezones
    |> Enum.map(fn path ->
      %Measurement{
        path: "TzData/Others/" <> path,
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
