defmodule DallasWeb.DashboardLive do
  use DallasWeb, :live_view

  alias DallasWeb.Router.Helpers, as: Routes

  alias Dallas.ResultSet

  @impl true
  def mount(params, _session, socket) do
    path = Map.get(params, "p", "/")

    node = ResultSet.get(path)

    {
      :ok,
      socket
      |> assign(current_node: node)
      |> assign(children_nodes: ResultSet.get_children(node))
      |> assign(page_title: node.name || "Overview")
    }
  end

  @impl true
  def handle_params(%{"p" => path}=_params, _uri, socket) do
    node = ResultSet.get(path)

    {
      :noreply,
      socket
      |> assign(current_node: node)
      |> assign(children_nodes: ResultSet.get_children(node))
      |> assign(page_title: node.name || "Overview")
    }
  end
  def handle_params(_, _uri, socket) do
    node = ResultSet.get("/")

    {
      :noreply,
      socket
      |> assign(current_node: node)
      |> assign(children_nodes: ResultSet.get_children(node))
      |> assign(page_title: node.name || "Overview")
    }
  end

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
