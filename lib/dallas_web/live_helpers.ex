defmodule DallasWeb.LiveHelpers do

  def dashboard_path(_socket, path) do
    # socket.private.connect_info.private.dallas_prefix <>
    "?" <> URI.encode_query(%{"path" => path})
  end

  def format_date(_datetime = nil), do: ""
  def format_date(datetime = %DateTime{}) do
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

  def background_by_level(:error), do: "bg-red-700"
  def background_by_level(:warning), do: "bg-yellow-600"
  def background_by_level(:ok), do: "bg-green-700"
end
