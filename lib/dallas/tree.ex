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

  def from_measurements(measurements) do
    nodes =
      from_measurements_rec(measurements, [])
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

  def from_measurements_rec(measurements, path \\ [])
  def from_measurements_rec(_measurements = [], _path) do
    []
  end
  def from_measurements_rec(measurements, path) do
    measurements
    |> Enum.group_by(fn m -> m.path |> String.split("/") |> Kernel.--(path) |> hd() end)
    |> Enum.map(&func(&1, path))
  end

  defp func({name, [measurement]}, path) do
    full_path = Enum.join(path, "/") <> "/#{name}" |> String.trim_leading("/")

    if full_path == measurement.path do
      %Node{
        path: full_path,
        name: name,
        is_leaf: true,
        children: []
      }
    else
      children = from_measurements_rec([measurement], path ++ [name])

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

  defp func({name, measurements}, path) do
    children = from_measurements_rec(measurements, path ++ [name])

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
