defmodule MovieCatalog.Movie do
  use MovieCatalog.Web, :model

  schema "movies" do
    field :title, :string
    field :description, :string
    field :cover_path, :string
    field :published, Ecto.Date
    belongs_to :user, MovieCatalog.User

    has_many :comments, MovieCatalog.Comment
    has_many :scores, MovieCatalog.Score

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :published, :cover_path])
    |> validate_required([:title, :description, :published, :cover_path])
  end
end
