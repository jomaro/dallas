defmodule DallasTest.Instrument.OkInstrument do
  use Dallas.Instrument, queue: :test_queue

  alias Dallas.Measurement

  def measure() do
    %Measurement{
      path: "Test instruments/Ok Instrument",
      level: :ok,
      value: "OK"
    }
  end
end
