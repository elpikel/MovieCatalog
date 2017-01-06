defmodule MovieCatalog.Session do
  alias MovieCatalog.User

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["plain_password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: MovieCatalog.Repo.get(User, id)
  end

  def current_user_id(conn), do: Plug.Conn.get_session(conn, :current_user)
  
  def logged_in?(conn), do: !!current_user(conn)

  defp authenticate(user, plain_password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(plain_password, user.password)
    end
  end
end
