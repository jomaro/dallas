defmodule Dallas.ResultSet do

  use GenServer

  alias Dallas.Tree
  alias Dallas.Tree.Node


  @spec update(any) :: nil | [any]
  def update(measurements) when is_list(measurements) do
    # measurements
    # |> Enum.chunk_every(20)
    # |> Enum.map(&GenServer.call(__MODULE__, {:update, &1}))

    GenServer.call(__MODULE__, {:update, measurements})
  end

  def update(measurement) do
    GenServer.call(__MODULE__, {:update, [measurement]}, 60_000)
  end

  def get(path) do
    get_tree()
    |> Map.fetch!(path)
  end

  @spec get_children(Dallas.Tree.Node.t()) :: [any]
  def get_children(node = %Node{}) do
    tree = get_tree()

    node
    |> Map.fetch!(:children)
    |> Enum.map(fn path -> tree[path] end)
  end

  def get_tree do
    GenServer.call(__MODULE__, :get)
  end

  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_stack) do
    {
      :ok,
      create_state([]),
    }
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state.tree, state}
  end

  @impl true
  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:update, measurements}, _from, state) do
    new = measurements ++ state.measurements

    {
      :reply,
      :ok,
      create_state(new),
    }
  end

  def create_state(measurements) do
    measurements_map =
      measurements
      |> Enum.map(fn item -> {item.path, item} end)
      |> Enum.into(%{})

    %{
      tree: Tree.from_measurements(measurements, measurements_map),
      measurements: measurements,
      measurements_map: measurements_map,
    }
  end
end
