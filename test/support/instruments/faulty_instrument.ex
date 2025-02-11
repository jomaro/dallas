defmodule DallasTest.Instrument.FaultyInstrument do
  use Dallas.Instrument, queue: :test_queue

  alias Dallas.Measurement

  def measure() do
    %Measurement{
      path: "Test instruments/Oh No Zero Division",
      level: :error,
      value: 1 / 0
    }
  end
end
