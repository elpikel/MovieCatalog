defmodule MovieCatalog.MovieControllerTest do
  use MovieCatalog.ConnCase

  alias MovieCatalog.Movie

  setup do
    user = insert_user(email: "max@max.pl")
    conn = assign(build_conn(), :current_user, user)
    {:ok, conn: conn, user: user}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Movie Catalog"
  end

  test "requires user authentication on all action except index", %{conn: conn} do
    Enum.each([
      get(conn, movie_path(conn, :new)),
      post(conn, movie_path(conn, :create, %{})),
      post(conn, movie_score_path(conn, :add_score, %Movie{id: 1})),
      post(conn, movie_comment_path(conn, :add_comment, %Movie{id: 1}))
      ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "lists all user's movies on index", %{conn: conn, user: user} do
    user_movies = insert_movie(user, title: "funny cats")
    other_movie = insert_movie(insert_user(email: "other@other.pl"), title: "another movie")

    conn = get(conn, movie_path(conn, :index))
    assert html_response(conn, 200) =~ ~r/LATEST TRAILERS/
    assert String.contains?(conn.resp_body, user_movies.title)
    assert String.contains?(conn.resp_body, other_movie.title)
  end
end
