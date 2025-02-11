defmodule Dallas.Worker do
  alias Dallas.ResultSet
  # alias Dallas.InstrumentMonitoring

  def run_instrument(instrument) do
    # InstrumentMonitoring.monitor(self(), instrument)

    instrument.measure()
    |> ResultSet.update()
  end
end
