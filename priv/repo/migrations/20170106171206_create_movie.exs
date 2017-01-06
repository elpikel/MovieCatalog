defmodule MovieCatalog.Repo.Migrations.CreateMovie do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :title, :string
      add :description, :string
      add :published, :date
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:movies, [:user_id])

  end
end
