defmodule Dallas.Tree do

  alias Dallas.Measurement

  @type level :: :error | :ok | :ignored | nil

  defmodule Node do
    defstruct [
      :path,
      :name,
      :level,
      :value,
      :unit,
      :is_leaf,
      :detail,
      :instrument,
      :execution_date,
      children: [],
      actions: [],
    ]
  end

  @spec from_measurements([Measurement.t()], %{String.t() => Measurement.t()})
         :: %{String.t() => Node.t()}
  def from_measurements(measurements, measurements_map) do
    nodes =
      from_measurements_rec(measurements, measurements_map, [])
      |> List.flatten
      |> Enum.map(fn measurement -> {measurement.path, measurement} end)
      |> Enum.into(%{})

    first_level =
      nodes
      |> Enum.map(&elem(&1, 0))
      |> Enum.reject(&String.contains?(&1, "/"))
      |> Enum.sort()

    nodes
    |> Map.put("/", %Node{
      path: "/",
      level: :ok,
      is_leaf: false,
      children: first_level,
    })
  end

  def from_measurements_rec(measurements, measurements_map, path \\ [])
  def from_measurements_rec(_measurements = [], _measurements_map, _path) do
    []
  end
  def from_measurements_rec(measurements, measurements_map, path) do
    measurements
    |> Enum.group_by(fn m -> m.path |> String.split("/") |> Kernel.--(path) |> hd() end)
    |> Enum.map(&func(&1, measurements_map, path))
  end

  defp func({name, [measurement]}, measurements_map, path) do
    full_path = Enum.join(path, "/") <> "/#{name}" |> String.trim_leading("/")

    my_measurement = measurements_map[full_path]

    unless is_nil(my_measurement) do
      %Node{
        path: full_path,
        name: name,
        value: my_measurement.value,
        level: my_measurement.level,
        is_leaf: true,
        unit: my_measurement.unit,
        detail: my_measurement.detail,
        actions: my_measurement.actions,
        execution_date: my_measurement.execution_date,
        children: []
      }
    else
      children = from_measurements_rec([measurement], measurements_map, path ++ [name])

      [
        %Node{
          path: full_path,
          name: name,
          level: get_level_from_children(children),
          is_leaf: false,
          children: children |> Enum.map(fn c -> c.path end) |> Enum.sort()
        },
        children
      ]
    end
  end

  defp func({name, measurements}, measurements_map, path) do
    children = from_measurements_rec(measurements, measurements_map, path ++ [name])

    [
      %Node{
        path: Enum.join(path, "/") <> "/#{name}" |> String.trim_leading("/"),
        name: name,
        level: get_level_from_children(children),
        is_leaf: false,
        children: children |> Enum.map(&get_path/1) |> Enum.reject(&is_nil/1) |> Enum.sort()
      },
      children
    ]
  end

  @spec get_level_from_children([Node.t()]) :: level()
  defp get_level_from_children(children) do
    children
    |> Enum.flat_map(&get_level/1)
    |> get_highest_level_by_precedence
  end

  @spec get_highest_level_by_precedence([level()]) :: level()
  defp get_highest_level_by_precedence([]), do: :ok
  defp get_highest_level_by_precedence(levels) do
    precedences = %{
      error: 10,
      ok: 5,
      ignored: 1,
    }

    levels
    |> Enum.max_by(&Map.get(precedences, &1, 0))
  end

  @spec get_level([any]) :: [level()]
  defp get_level([%Node{level: level}, _]), do: [level]
  defp get_level(%Node{level: level}), do: [level]
  defp get_level(_), do: []

  @spec get_path(any()) :: [String.t()]
  defp get_path([%Node{path: path}, _]), do: path
  defp get_path(%Node{path: path}), do: path
  defp get_path(_), do: nil
end
