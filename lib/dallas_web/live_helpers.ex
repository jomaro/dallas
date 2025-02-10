defmodule DallasWeb.LiveHelpers do

  def dashboard_path(_socket, path) do
    # socket.private.connect_info.private.dallas_prefix <>
    "?" <> URI.encode_query(%{"path" => path})
  end

  def format_date(_datetime = nil), do: ""
  def format_date(datetime = %DateTime{}) do
    if DateTime.to_date(datetime) == Date.utc_today() do
      Calendar.strftime(datetime, "%H:%M:%S")
    else
      Calendar.strftime(datetime, "%Y-%m-%d %H:%M:%S")
    end
  end

  def background_by_level(level), do: "bg-red-700"
  def background_by_level(:warning), do: "bg-yellow-600"
  def background_by_level(:ok), do: "bg-green-700"
  
  def color_by_level(:error), do: "red-700"
  def color_by_level(:warning), do: "yellow-600"
  def color_by_level(:ok), do: "green-700"
end
