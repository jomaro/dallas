defmodule DallasWeb.DashboardLive do
  use DallasWeb, :live_view

  alias Dallas.ResultSet

  @impl true
  def mount(params, _session, socket) do
    path = Map.get(params, "p", "/")

    {
      :ok,
      assign(socket, current_node: ResultSet.get(path))
    }
  end

  @impl true
  def handle_event("navigate", %{"p" => path}, socket) do
    measurements = ResultSet.get(path)

    {
      :noreply,
      assign(socket, current_node: ResultSet.get(path))
    }
  end

  @impl true
  def handle_event("open", %{"p" => path}, socket) do
    {
      :noreply,
      socket
      |> assign(current_node: ResultSet.get(path))
    }
  end

  def get_children(node) do
    ResultSet.get_children(node)
  end

  def get_breadcrumb_links("/"), do: []
  def get_breadcrumb_links(path) do
    get_path_parts(path)
    |> Enum.zip(get_partial_paths(path))
  end

  defp get_path_parts(path) do
    path
    |> String.split("/")
  end

  defp get_partial_paths(path) when is_binary(path) do
    get_path_parts(path)
    |> get_partial_paths()
    |> Enum.map(&Enum.join(&1, "/"))
  end

  defp get_partial_paths([part]) do
    [[part]]
  end
  defp get_partial_paths([part | tail]) do
    appended = for p <- get_partial_paths(tail) do
      [part | p]
    end

    [[part] | appended]
  end
end
