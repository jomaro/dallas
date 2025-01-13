defmodule DallasWeb.Breadcrumbs do
  # In Phoenix apps, the line is typically: use MyAppWeb, :live_component
  use DallasWeb, :live_component

  attr :path, :string, required: true

  def render(assigns) do
    ~H"""
    <section class="px-3 py-2 text-lg">
      <.link patch={dashboard_path(@socket, "/")}>
      <span class="action">Home</span>
      </.link>
      <%= for {part, link} <- get_breadcrumb_links(@path) do %>
        <span>/</span>
        <.link patch={dashboard_path(@socket, link)}>
        <span class="action"><%= part %></span>
        </.link>
      <% end %>
    </section>
    """
  end

  defp get_breadcrumb_links("/"), do: []
  defp get_breadcrumb_links(path) do
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
