defmodule DallasTest.Instrument.ErrorInstrument do
  use Dallas.Instrument, queue: :test_queue

  alias Dallas.Measurement

  def measure() do
    %Measurement{
      path: "Test instruments/Error Instrument",
      level: :error,
      value: "Something is broken here"
    }
  end
end
