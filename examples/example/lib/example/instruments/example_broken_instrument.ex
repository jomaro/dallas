
defmodule Example.Instruments.ExampleBrokenInstrument do
  # use Dallas.Instrument

  alias Dallas.Measurement

  def measure do
    error = 3 / 0
    
    %Measurement{
      path: "This should not be seem/"  <> error,
      level: :ok,
      value: 0,
      detail: "Everything ok",
    }
  end
end