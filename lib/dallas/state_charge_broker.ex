defmodule Dallas.StateChangeBroker do
  use GenServer

  def subscribe(path) do
    clear()
    GenServer.call(__MODULE__, {:subscribe, path})
  end
  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def notify(path) do
    for pid <- GenServer.call(__MODULE__, {:get_path, path}) do
      Process.send(pid, :update, [])
    end
  end

  def clear() do
    GenServer.cast(__MODULE__, :clear)
  end

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:subscribe, path}, _from = {pid, _ref}, state) do
    {
      :reply,
      :ok,
      state |> Map.update(path, [pid], fn listeners -> [pid | listeners] end)
    }
  end

  def handle_call({:get_path, path}, _from, state) do
    {
      :reply,
      Map.get(state, path, []),
      state,
    }
  end

  def handle_call(:get_state, _from, state) do
    {
      :reply,
      state,
      state,
    }
  end

  @impl true
  def handle_cast(:clear, _state) do
    {:noreply, %{}}
  end
end
