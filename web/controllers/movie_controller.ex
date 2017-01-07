defmodule MovieCatalog.MovieController do
  use MovieCatalog.Web, :controller

  plug :authenticate_user when action in [:new, :create]

  alias MovieCatalog.Movie
  alias MovieCatalog.Session

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:movies)
      |> Movie.changeset()

    render conn, changeset: changeset
  end

  def create(conn, %{"movie" => movie_params}, user) do
    changeset =
      user
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

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, MovieCatalog.Session.current_user(conn)])
  end
end
