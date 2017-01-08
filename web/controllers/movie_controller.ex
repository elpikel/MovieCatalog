defmodule MovieCatalog.MovieController do
  use MovieCatalog.Web, :controller

  plug :authenticate_user when action in [:new, :create]

  alias MovieCatalog.Movie

  def index(conn, params, user) do
    movies = MovieCatalog.Repo.all(MovieCatalog.Movie)
    render conn, movies: movies
  end

  def show(conn, %{"id" => id}, user) do
    movie = MovieCatalog.Repo.get(MovieCatalog.Movie, id)
    render conn, movie: movie
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:movies)
      |> Movie.changeset()

    render conn, changeset: changeset
  end

  def create(conn, %{"movie" => movie_params}, user) do
    movie_params = save_file(movie_params, user)
    user = build_assoc(user, :movies)

    changeset = Movie.changeset(user, movie_params)

    case MovieCatalog.Repo.insert(changeset) do
      {:ok, _changeset} ->
        conn
        |> put_flash(:info, "Movie was published")
        |> redirect(to: "/")
      {:error, movie} ->
        conn
        |> put_flash(:info, "Unable to publish movie")
        |> render("new.html", changeset: movie)
    end
  end

  defp save_file(movie_params, user) do
    case upload = movie_params["cover"] do
      nil ->
        movie_params
      _ ->
        extension = Path.extname(upload.filename)
        cover_path = "/media/#{user.id}-#{movie_params["title"]}#{extension}"
        File.cp!(upload.path, cover_path)

        Map.put(movie_params, "cover_path", cover_path)
    end
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, MovieCatalog.Session.current_user(conn)])
  end
end
