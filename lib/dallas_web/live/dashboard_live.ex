defmodule DallasWeb.DashboardLive do
  use DallasWeb, :live_view

  alias DallasWeb.Router.Helpers, as: Routes

  alias Dallas.ResultSet

  @impl true
  def mount(params, _session, socket) do
    path = Map.get(params, "p", "/")

    {
      :ok,
      assign(socket, current_node: ResultSet.get(path))
    }
  end

  # @impl true
  # def handle_event("navigate", %{"p" => path}, socket) do
  #   {
  #     :noreply,
  #     push_redirect(
  #       socket,
  #       to: Routes.dashboard_path(socket, :index, path)
  #     )
  #   }
  # end

  @impl true
  def handle_event("open", %{"p" => path}, socket) do
    node = ResultSet.get(path)

    {
      :noreply,
      socket
      |> assign(current_node: node, children_nodes: ResultSet.get_children(node))
    }
  end

  @impl true
  def handle_params(%{"p" => path}=_params, _uri, socket) do
    node = ResultSet.get(path)

    {
      :noreply,
      socket
      |> assign(current_node: node, children_nodes: ResultSet.get_children(node))
    }
  end
  def handle_params(_, _uri, socket) do
    node = ResultSet.get("/")

    {
      :noreply,
      socket
      |> assign(current_node: node, children_nodes: ResultSet.get_children(node))
    }
  end

  def get_children(node) do
    ResultSet.get_children(node)
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
