defmodule MovieCatalog.MovieController do
  use MovieCatalog.Web, :controller

  plug :authenticate when action in [:new, :create]

  alias MovieCatalog.Movie
  alias MovieCatalog.Session

  def new(conn, params) do
    changeset =
      MovieCatalog.Session.current_user(conn)
      |> build_assoc(:movies)
      |> Movie.changeset()

    render conn, changeset: changeset
  end

  def create(conn, %{"movie" => movie_params}) do
    changeset =
      MovieCatalog.Session.current_user(conn)
      |> build_assoc(:movies)
      |> Movie.changeset(movie_params)

    case MovieCatalog.Repo.insert(changeset) do
      {:ok, _changeset} ->
        conn
        |> put_flash(:info, "Movie was published")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to publish movie")
        |> render("new.html", changeset: changeset)
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "you must be logged in to access that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
