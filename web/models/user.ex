defmodule MovieCatalog.User do
  use MovieCatalog.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string
    field :plain_password, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    params = Map.put(params, "password", hashed_password(params["plain_password"]))

    struct
    |> cast(params, [:email, :password, :plain_password])
    |> validate_required([:email, :plain_password, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:plain_password, min: 5)
  end

  defp hashed_password(nil), do: ""
  defp hashed_password(""), do: ""
  defp hashed_password(password), do: Comeonin.Bcrypt.hashpwsalt(password)
end
