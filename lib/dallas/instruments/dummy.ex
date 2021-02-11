defmodule Dallas.Instrument.Dummy do

  alias Dallas.Measurement

  def measure do
    [
      %Measurement{
        path: "Dummy/the ok one",
        level: :ok,
        value: "OK",
        detail: "Nothing to see here",
      },
      %Measurement{
        path: "Dummy/the nok one",
        level: :error,
        value: "Wrong",
        detail: "Something went wrong here",
      },
      %Measurement{
        path: "missplaced",
        level: :ok,
        value: "OK",
        detail: "this guy is missplaced on the root, who did this?",
      },
    ]
  end

end
