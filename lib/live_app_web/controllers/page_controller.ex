defmodule LiveAppWeb.PageController do
  use LiveAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
