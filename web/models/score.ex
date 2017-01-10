defmodule MovieCatalog.Score do
  use MovieCatalog.Web, :model

  schema "scores" do
    field :points, :integer
    belongs_to :user, MovieCatalog.User
    belongs_to :movie, MovieCatalog.Movie

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:points, :movie_id])
    |> validate_required([:points])
  end
end
