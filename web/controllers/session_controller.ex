defmodule MovieCatalog.SessionController do
  use MovieCatalog.Web, :controller

  alias MovieCatalog.Session
  alias MovieCatalog.Repo
  alias MovieCatalog.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, Repo) do
    {:ok, user} ->
      conn
      |> Auth.login(user)
      |> put_flash(:info, "Logged in")
      |> redirect(to: "/")
    :error ->
      conn
      |> put_flash(:info, "Wrong email or password")
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
