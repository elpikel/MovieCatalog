defmodule MovieCatalog.MovieController do
  use MovieCatalog.Web, :controller

  plug :authenticate_user when action in [:new, :create]

  alias MovieCatalog.Movie
  alias MovieCatalog.Comment
  alias MovieCatalog.Score

  def index(conn, _params, _user) do
    movies = MovieCatalog.Repo.all(Movie)
    render conn, movies: movies
  end

  def show(conn, %{"id" => movie_id}, _user) do
    movie = MovieCatalog.Repo.get(Movie, movie_id)
    movie = Repo.preload(movie, :comments)
    score = get_score(movie_id)

    IO.inspect score
    render conn, [movie: movie, score: score, changeset: Comment.changeset(%Comment{})]
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

  def add_score(conn, %{"movie_id" => movie_id, "score" => score}, user) do
    changeset = Score.changeset(%Score{user_id: user.id}, Map.put(score, "movie_id", movie_id))
    movie = MovieCatalog.Repo.get(MovieCatalog.Movie, movie_id)

    case MovieCatalog.Repo.insert(changeset) do
      {:ok, _changeset} ->
        conn
        |> put_flash(:info, "Movie was scored")
        |> redirect(to: movie_path(conn, :show, movie))
      {:error, score} ->
        conn
        |> put_flash(:info, "Unable to score movie")
        |> render(conn, "show.html", %{movie: movie, score: score})
    end
  end

  def add_comment(conn, %{"comment" => comment_params, "movie_id" => movie_id}, user) do
    comment_params = Map.put(comment_params, "movie_id", movie_id)

    changeset = Comment.changeset(
      %Comment{user_id: user.id},
      comment_params
    )
    movie = MovieCatalog.Repo.get(MovieCatalog.Movie, movie_id)
    case MovieCatalog.Repo.insert(changeset) do
      {:ok, _changeset} ->
        conn
        |> put_flash(:info, "Movie was published")
        |> redirect(to: movie_path(conn, :show, movie))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to publish movie")
        |> render(conn, "show.html", %{movie: movie, changeset: changeset})
    end
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, MovieCatalog.Session.current_user(conn)])
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

  defp get_score(movie_id) do
    score_query = from s in Score,
        where: s.movie_id == ^movie_id,
        select: %{count: count(s.id), sum: sum(s.points)}

    score = MovieCatalog.Repo.one(score_query)

    calculate_score(score.count, score.sum)
  end

  defp calculate_score(0, _), do: 0
  defp calculate_score(count, sum), do: sum / count
end
