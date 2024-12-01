defmodule Dallas.DashboardLive do
  use Phoenix.LiveView

  alias Dallas.ResultSet

  @impl true
  def mount(params, session, socket) do
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

  defp background_by_level(:error), do: "bg-red-700"
  defp background_by_level(:warning), do: "bg-yellow-600"
  defp background_by_level(:ok), do: "bg-green-700"

  def breadcrumbs(socket, path) do
    assigns = %{
      socket: socket,
      path: path
    }

    ~H"""
    <section class="px-3 py-2 text-lg">
      <%= live_patch to: dashboard_path(@socket, "/") do %>
      <span class="action">Home</span>
      <% end %>
      <%= for {part, link} <- get_breadcrumb_links(@path) do %>
        <span>/</span>
        <%= live_patch to: dashboard_path(@socket, link) do %>
        <span class="action"><%= part %></span>
        <% end %>
      <% end %>
    </section>
    """
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

  def dashboard_path(socket, path) do
    socket.private.connect_info.private.dallas_prefix <> "?" <> URI.encode_query(%{"path" => path})
  end

  defp format_date(_datetime = nil), do: ""
  defp format_date(datetime = %DateTime{}) do
    if DateTime.to_date(datetime) == Date.utc_today() do
      datetime
      |> DateTime.to_time()
      |> Time.to_iso8601()
      |> String.split(".")
      |> hd()
    else
      datetime
      |> DateTime.to_naive()
      |> NaiveDateTime.to_iso8601()
      |> String.split(".")
      |> hd()
      |> String.replace("T", " ")
    end
  end

  defp ok(result) do
    {:ok, result}
  end
end
