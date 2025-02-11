defmodule Dallas.Instruments.BrokenInstruments do
  use Dallas.Instrument

  alias Dallas.Measurement

  def measure() do
    Dallas.BrokenInstrument.get()
    |> Enum.map(fn {instrument, count} ->
      %Measurement{
        path: "Meta/Broken Instruments/#{instrument}",
        level: :error,
        value: count,
        detail: ""
      }
    end)
  end
end
