defmodule Dallas.Scheduler do
  use GenServer

  alias Dallas.Instrument
  alias Dallas.Worker

  require Logger

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link({queue, concurrency}) do
    instruments =
      Instrument.get_whitelisted_instruments(queue)

    state = %{
      queue: queue,
      current_execution_queue: [],
      instruments: instruments,
      concurrency: concurrency
    }

    GenServer.start_link(__MODULE__, state, name: Module.concat(__MODULE__, queue))
  end

  @impl true
  def init(state) do
    Process.send_after(self(), :work, 1_000)

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    run_instruments(state)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 30_000)
  end

  def run_instruments(state) do
    Logger.info("[Scheduler] Starting queue #{state.queue}")

    state.instruments
    |> Enum.map(fn instrument ->
      # there are better approaches here, we should spawn processes to have concurrency
      # but we need to do it in a way they are unlinked from the scheduler process
      # 
      # Being unlinked we need to call Process.monitor on them so we will receive a message if they fail
      #this will have to be a future improvement though
      try do
        Worker.run_instrument(instrument)
      rescue
        e ->
          Logger.error("[Scheduler] Running instrument #{instrument} failed with error: #{inspect(e)}")
      end
    end)
    |> Stream.run()

    Logger.info("[Scheduler] Finishing queue #{state.queue}")
  end
end
