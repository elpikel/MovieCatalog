defmodule MovieCatalog.Comment do
  use MovieCatalog.Web, :model

  schema "comments" do
    field :message, :string
    belongs_to :user, MovieCatalog.User
    belongs_to :movie, MovieCatalog.Movie

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message])
    |> validate_required([:message])
  end
end
