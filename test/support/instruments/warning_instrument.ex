defmodule DallasTest.Instrument.WarningInstrument do
  use Dallas.Instrument, queue: :test_queue

  alias Dallas.Measurement

  def measure() do
    %Measurement{
      path: "Test instruments/Warning Instrument",
      level: :warning,
      value: "Something is not right"
    }
  end
end
