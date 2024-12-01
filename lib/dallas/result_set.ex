defmodule Dallas.ResultSet do

  use GenServer

  alias Dallas.Measurement
  alias Dallas.Tree
  alias Dallas.Tree.Node

  @spec update([Measurement.t()]) :: :ok
  def update(measurements) when is_list(measurements) do
    GenServer.call(__MODULE__, {:update, measurements})
  end

  @spec get(String.t()) :: Dallas.Tree.Node.t()
  def get(path) do
    get_tree()
    |> Map.get(path)
  end

  @spec get_children(Dallas.Tree.Node.t()) :: [Dallas.Tree.Node.t()]
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

  def start_link(initial_state \\ []) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  @impl GenServer
  def init(initial_state) do
    {
      :ok,
      create_state(initial_state),
    }
  end

  @impl GenServer
  def handle_call(:get, _from, state) do
    {:reply, state.tree, state}
  end

  @impl GenServer
  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_call({:update, measurements}, _from, old_state) do
    instruments =
      MapSet.new(measurements, fn item -> item.instrument end)

    new_state_measurements = measurements ++ Enum.reject(old_state.measurements, fn measurement -> measurement.instrument in instruments end)

    new_state = create_state(new_state_measurements)

    update_changed_paths(old_state, new_state)

    {
      :reply,
      :ok,
      new_state,
    }
  end

  def create_state(measurements) do
    measurements_map =
      Map.new(measurements, fn item -> {item.path, item} end)

    %{
      tree: Tree.from_measurements(measurements, measurements_map),
      measurements: measurements,
      measurements_map: measurements_map,
    }
  end

  def update_changed_paths(old_state, new_state) do
    paths =
      old_state.tree
      |> Map.keys()
      |> Stream.concat(new_state.tree |> Map.keys())
      |> Enum.into(MapSet.new)


    paths_to_update =
      for path <- paths do
        if old_state.tree[path] != new_state.tree[path] do
          path
        end
      end
      |> Enum.reject(&is_nil/1)
      |> Enum.flat_map(fn path -> [path, get_parent_path(path)] end)
      |> Enum.into(MapSet.new)

      paths_to_update
  end

  defp get_parent_path(path) do
    if String.contains?(path, "/") do
      [_last | others] = path |> String.split("/") |> Enum.reverse()

      others
      |> Enum.reverse()
      |> Enum.join("/")
    else
      "/"
    end
  end
end
