defmodule MovieCatalog.MovieControllerTest do
  use MovieCatalog.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Movie Catalog"
  end
end
