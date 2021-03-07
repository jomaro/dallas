defmodule Dallas.StateChangeBroker do
  use GenServer

  def subscribe(path, old_path) do
    GenServer.call(__MODULE__, {:subscribe, path, old_path})
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def notify(path) do
    for pid <- GenServer.call(__MODULE__, {:get_path, path}) do
      Process.send(pid, :update, [])
    end
  end

  defp put_new_listener(map, path, pid) do
    map
    |> Map.update(path, [pid],
        fn listeners ->
          list_put_new(listeners, pid)
          |> Enum.filter(&Process.alive?/1)
        end)
  end

  defp list_put_new(list, elem) do
    if elem in list do
      list
    else
      [elem | list]
    end
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
  def handle_call({:subscribe, path, nil}, _from = {pid, _ref}, state) do
    {
      :reply,
      :ok,
      state
      |> put_new_listener(path, pid)
    }
  end

  def handle_call({:subscribe, path, old_path}, _from = {pid, _ref}, state) do
    {
      :reply,
      :ok,
      state
      |> Map.update(old_path, [], fn listeners -> listeners -- [pid] end)
      |> put_new_listener(path, pid)
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
end
