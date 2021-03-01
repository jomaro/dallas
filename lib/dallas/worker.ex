defmodule Dallas.Worker do

  alias Dallas.ResultSet

  def run_instrument(instrument) do
    instrument.measure()
    |> ResultSet.update()
  end
end
