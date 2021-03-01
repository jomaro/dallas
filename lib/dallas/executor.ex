defmodule Dallas.Executor do
  use GenServer

  alias Dallas.Instrument
  alias Dallas.Worker

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(options) do
    {instrument_type, options} = options |> Keyword.pop!(:instrument_type)

    queue = Instrument.get_whitelisted_instruments(instrument_type)

    state = %{
      queue: queue,
      current_execution_queue: [],
      options: options,
      queue_name: instrument_type,
    }

    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(state) do
    :erlang.send_after(1_000, self(), :work)

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    do_recurrent_thing(state)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    :erlang.send_after(30_000, self(), :work)
  end

  defp do_recurrent_thing(state) do
    # IO.inspect "Running"

    n_workers = Keyword.get(state.options, :workers, 1)

    state.queue
    |> Task.async_stream(&Worker.run_instrument/1, max_concurrency: n_workers)
    |> Stream.run

    # IO.inspect "Stopping"
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, head}, tail) do
    {:noreply, [head | tail]}
  end
end
