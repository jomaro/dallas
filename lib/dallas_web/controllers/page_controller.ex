defmodule DallasWeb.PageController do
  use DallasWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/overview")
  end
end
