defmodule Dallas.Tree do
  defmodule Node do
    defstruct [
      :path,
      :name,
      :level,
      :is_leaf,
      children: [],
    ]
  end

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

    if full_path == measurement.path do
      %Node{
        path: full_path,
        name: name,
        is_leaf: true,
        children: []
      }
    else
      children = from_measurements_rec([measurement], measurements_map, path ++ [name])

      [
        %Node{
          path: full_path,
          name: name,
          is_leaf: false,
          children: children |> Enum.map(fn c -> c.path end)
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
        is_leaf: false,
        children: children |> Enum.map(&get_path/1) |> Enum.reject(&is_nil/1)
      },
      children
    ]
  end

  defp get_path([%Node{path: path}, _]), do: path
  defp get_path(%Node{path: path}), do: path
  defp get_path(_), do: nil
end
