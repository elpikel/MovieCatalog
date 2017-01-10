defmodule MovieCatalog.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :points, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :movie_id, references(:movies, on_delete: :nothing)

      timestamps()
    end
    create index(:scores, [:user_id])
    create index(:scores, [:movie_id])

  end
end
