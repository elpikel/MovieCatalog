defmodule MovieCatalog.Repo.Migrations.AddCoverUrlToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies) do
      add :cover_path, :string
    end
  end
end
