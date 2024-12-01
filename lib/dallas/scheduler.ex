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
      concurrency: concurrency,
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
    do_recurrent_thing(state)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 30_000)
  end

  defp do_recurrent_thing(state) do
    Logger.info "[Scheduler] Starting queue #{state.queue}"

    state.instruments
    |> Task.async_stream(&Worker.run_instrument/1, max_concurrency: state.concurrency)
    |> Stream.run()

    Logger.info "[Scheduler] Finishing queue #{state.queue}"
  end
end
