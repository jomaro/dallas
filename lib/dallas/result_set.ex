defmodule Dallas.ResultSet do

  use GenServer

  alias Dallas.Tree
  alias Dallas.Tree.Node
  alias Dallas.Measurement

  @measurements [
    %Measurement{
      path: "America/São Paulo/Bras",
      level: :ok,
      detail: "Everything OK",
      value: "0/12",
    },
    %Measurement{
      path: "America/Brasilia",
      level: :error,
      detail: "something is definitely wrong",
      value: "1/12",
    },
    %Measurement{
      path: "America/Manaus",
      level: :error,
      detail: "something is wrong",
      value: "2/12",
    },
    %Measurement{
      path: "Europe/Berlim",
      level: :ok,
      detail: "Everything OK",
      value: "3/12",
    },
    %Measurement{
      path: "Europe/Paris",
      level: :error,
      detail: "something is wrong",
      value: "4/12",
    },
    %Measurement{
      path: "Oceania/Sidney",
      level: :ok,
      detail: "Everything OK",
      value: "5/12",
    },
  ]

  @spec update(any) :: nil | [any]
  def update(measurements) when is_list(measurements) do
    measurements
    |> Enum.map(&update/1)
  end

  def update(measurement) do
    GenServer.cast(__MODULE__, {:update, measurement})
  end

  def get(path) do
    get_tree()
    |> Map.fetch!(path)
  end

  def get_children(node = %Node{}) do
    tree = get_tree()

    node
    |> Map.fetch!(:children)
    |> Enum.map(fn path -> tree[path] end)
  end

  def get_tree do
    get_all()
  end

  defp get_all() do
    GenServer.call(__MODULE__, :get)
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_stack) do
    {
      :ok,
      create_state(@measurements),
    }
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state.tree, state}
  end

  @impl true
  def handle_call({:update, measurements}, _from, state) do
    new = measurements ++ state.measurements

    {
      :noreply,
      create_state(new),
    }
  end

  defp create_state(measurements) do
    %{
      tree: Tree.from_measurements(measurements),
      measurements: measurements,
      measurements_map: measurements |> Enum.map(fn item -> {item.path, item} end) |> Enum.into(%{}),
    }
  end
end
