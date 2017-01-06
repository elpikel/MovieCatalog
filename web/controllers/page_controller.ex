defmodule MovieCatalog.PageController do
  use MovieCatalog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
