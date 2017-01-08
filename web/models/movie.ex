defmodule MovieCatalog.Movie do
  use MovieCatalog.Web, :model

  schema "movies" do
    field :title, :string
    field :description, :string
    field :cover_path, :string
    field :published, Ecto.Date
    belongs_to :user, MovieCatalog.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    IO.inspect(params)
    struct
    |> cast(params, [:title, :description, :published, :cover_path])
    |> validate_required([:title, :description, :published, :cover_path])
  end
end
