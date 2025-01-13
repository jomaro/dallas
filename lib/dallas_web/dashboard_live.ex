defmodule Dallas.DashboardLive do
  use DallasWeb, :live_view

  alias Dallas.ResultSet

  @impl true
  def mount(params, _session, socket) do
    path = Map.get(params, "path", "/")

    node =
      ResultSet.get_tree()
      |> Map.get(path)

    socket
    |> assign_state(node, path)
    |> ok()
  end

  @spec assign_state(Phoenix.LiveView.Socket.t(), Node.t(), String.t()) :: Phoenix.LiveView.Socket.t()
  defp assign_state(socket, _node=nil, path) do
    socket
    |> assign(path: path)
    |> assign(lost_path: path)
    |> assign(current_node: nil)
    |> assign(children_nodes: [])
    |> assign(page_title: "Unknown")
  end

  defp assign_state(socket, node, path) do
    socket
    |> assign(path: path)
    |> assign(current_node: node)
    |> assign(children_nodes: ResultSet.get_children(node))
    |> assign(page_title: node.name || "Overview")
    |> assign(lost_path: nil)
  end
end
