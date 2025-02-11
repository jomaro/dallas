defmodule Dallas.BrokenInstrument do
  use GenServer

  def clean(instrument) do
    GenServer.cast(__MODULE__, {:clean, instrument})
  end

  def increase(instrument) do
    GenServer.cast(__MODULE__, {:increase, instrument})
  end

  def get() do
    GenServer.call(__MODULE__, :get)
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
  def handle_cast({:clean, instrument}, state) do
    state = Map.drop(state, [instrument])

    {:noreply, state}
  end

  def handle_cast({:increase, instrument}, state) do
    state = Map.update(state, instrument, 1, fn value -> value + 1 end)

    {:noreply, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
