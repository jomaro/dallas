defmodule DallasWeb.LayoutView do
  use DallasWeb, :view

  @favicon_non_dashboard "❤️"
  @favicon_ok "👍"
  @favicon_error "👎"

  def favicon(assigns) do
    case Map.get(assigns, :current_node) do
      nil -> @favicon_non_dashboard
      %{level: :ok} -> @favicon_ok
      %{level: :none} -> @favicon_ok
      _ -> @favicon_error
    end
  end
end
