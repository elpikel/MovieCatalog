defmodule MovieCatalog.User do
  use MovieCatalog.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string
    field :plain_password, :string, virtual: true

    has_many :movies, MovieCatalog.Movie
    has_many :scores, MovieCatalog.Score
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :plain_password])
    |> validate_required([:email, :plain_password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:plain_password, min: 5)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{plain_password: pass}} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
