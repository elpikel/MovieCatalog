defmodule MovieCatalog.TestHelpers do
  alias MovieCatalog.Repo
  alias MovieCatalog.User
  alias MovieCatalog.Movie

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
        email: "email@email1.com",
        plain_password: "plainpassword"
      }, attrs)

    %User{}
    |> User.changeset(changes)
    |> Repo.insert!()
  end

  def insert_movie(user, attrs \\ %{}) do
    changes = Dict.merge(%{
        title: "movie",
        description: "description",
        cover_path: "cover",
        published: Ecto.Date.utc()
      }, attrs)

    user
    |> Ecto.build_assoc(:movies, changes)
    |> Repo.insert!()
  end
end
