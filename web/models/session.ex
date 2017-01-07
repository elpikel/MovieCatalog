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
    conn.assigns.current_user
  end

  def current_user_id(conn), do: current_user(conn).id

  def logged_in?(conn), do: !!current_user(conn)

  defp authenticate(user, plain_password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(plain_password, user.password)
    end
  end
end
