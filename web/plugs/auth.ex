defmodule MovieCatalog.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias MovieCatalog.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        conn
      user = user_id && repo.get(MovieCatalog.User, user_id)
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end

    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "you must be logged in to access that page")
      |> redirect(to: Helpers.movie_path(conn, :index))
      |> halt()
    end
  end
end
