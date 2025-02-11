defmodule Dallas.SchedulerTest do
  use ExUnit.Case

  alias Dallas.Measurement
  alias Dallas.Scheduler
  alias Dallas.ResultSet

  test "Running an instrument should make it appear on the ResultSet" do
    %{
      queue: :test_queue,
      concurrency: 1,
      instruments: [
        DallasTest.Instrument.OkInstrument,
        DallasTest.Instrument.ErrorInstrument,
        DallasTest.Instrument.WarningInstrument,
      ]
    }
    |> Scheduler.run_instruments()

    assert %Measurement{
             path: "Test instruments/Ok Instrument",
             level: :ok,
             detail: nil,
             value: "OK",
             unit: nil,
             instrument: DallasTest.Instrument.OkInstrument,
             execution_date: %DateTime{},
             actions: [{"go to source", _}]
           } = ResultSet.get_measurement("Test instruments/Ok Instrument")
    
    assert %Measurement{
             path: "Test instruments/Error Instrument",
             level: :error,
             detail: nil,
             value: "Something is broken here",
             unit: nil,
             instrument: DallasTest.Instrument.ErrorInstrument,
             execution_date: %DateTime{},
             actions: [{"go to source", _}]
           } = ResultSet.get_measurement("Test instruments/Error Instrument")
    
    assert %Measurement{
             path: "Test instruments/Warning Instrument",
             level: :warning,
             detail: nil,
             value: "Something is not right",
             unit: nil,
             instrument: DallasTest.Instrument.WarningInstrument,
             execution_date: %DateTime{},
             actions: [{"go to source", _}]
           } = ResultSet.get_measurement("Test instruments/Warning Instrument")
  end
  
  test "Running a broken instrument should not crash the queue" do
    %{
      queue: :test_queue,
      concurrency: 1,
      instruments: [
        DallasTest.Instrument.FaultyInstrument,
        DallasTest.Instrument.OkInstrument,
        DallasTest.Instrument.ErrorInstrument,
        DallasTest.Instrument.WarningInstrument,
      ]
    }
    |> Scheduler.run_instruments()

    assert %Measurement{
             path: "Test instruments/Ok Instrument",
             level: :ok,
             detail: nil,
             value: "OK",
             unit: nil,
             instrument: DallasTest.Instrument.OkInstrument,
             execution_date: %DateTime{},
             actions: [{"go to source", _}]
           } = ResultSet.get_measurement("Test instruments/Ok Instrument")
    
    assert %Measurement{
             path: "Test instruments/Error Instrument",
             level: :error,
             detail: nil,
             value: "Something is broken here",
             unit: nil,
             instrument: DallasTest.Instrument.ErrorInstrument,
             execution_date: %DateTime{},
             actions: [{"go to source", _}]
           } = ResultSet.get_measurement("Test instruments/Error Instrument")
    
    assert %Measurement{
             path: "Test instruments/Warning Instrument",
             level: :warning,
             detail: nil,
             value: "Something is not right",
             unit: nil,
             instrument: DallasTest.Instrument.WarningInstrument,
             execution_date: %DateTime{},
             actions: [{"go to source", _}]
           } = ResultSet.get_measurement("Test instruments/Warning Instrument")
  end
end
