defmodule Dallas.InstrumentMonitoring do
  use GenServer

  def monitor(pid, instrument) do
    GenServer.call(__MODULE__, {:monitor, pid, instrument})
  end

  # Callbacks
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:monitor, pid, instrument}, _from, state) do
    ref = Process.monitor(pid)

    state = Map.put(state, ref, instrument)

    {:reply, :ok, state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, :normal}, state) do
    state = Map.drop(state, [ref])

    {:noreply, state}
  end

  def handle_info(msg, _state) do
    dbg(msg)

    {:noreply, nil}
  end
end
