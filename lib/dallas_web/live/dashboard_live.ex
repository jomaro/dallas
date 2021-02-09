defmodule DallasWeb.DashboardLive do
  use DallasWeb, :live_view

  alias DallasWeb.Router.Helpers, as: Routes

  alias Dallas.ResultSet
  alias Dallas.Tree.Node

  @impl true
  def mount(params, _session, socket) do
    path = Map.get(params, "p", "/")

    node = ResultSet.get(path)

    {
      :ok,
      assign_state(socket, node, path)
    }
  end

  @impl true
  def handle_params(%{"p" => path}=_params, _uri, socket) do
    node = ResultSet.get(path)

    {
      :noreply,
      assign_state(socket, node, path)
    }
  end
  def handle_params(_, _uri, socket) do
    node = ResultSet.get("/")

    {
      :noreply,
      assign_state(socket, node, "/")
    }
  end

  @spec assign_state(Phoenix.LiveView.Socket.t(), Node.t(), String.t()) :: Phoenix.LiveView.Socket.t()
  defp assign_state(socket, _node=nil, path) do
    socket
    |> assign(lost_path: path)
  end

  defp assign_state(socket, node, _path) do
    socket
    |> assign(current_node: node)
    |> assign(children_nodes: ResultSet.get_children(node))
    |> assign(page_title: node.name || "Overview")
    |> assign(lost_path: nil)
  end

  @spec get_breadcrumb_links(String.t()) :: [{String.t(), String.t()}]
  def get_breadcrumb_links("/"), do: []
  def get_breadcrumb_links(path) do
    parts = String.split(path, "/")

    for {part, index} <- Enum.with_index(parts, 1) do
      {
        part,
        parts
        |> Enum.take(index)
        |> Enum.join("/")
      }
    end
  end
end
