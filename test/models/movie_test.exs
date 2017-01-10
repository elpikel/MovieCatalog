defmodule MovieCatalog.MovieTest do
  use MovieCatalog.ModelCase

  alias MovieCatalog.Movie

  @valid_attrs %{
    description: "some content",
    published: %{day: 17, month: 4, year: 2010},
    title: "some content",
    cover_path: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Movie.changeset(%Movie{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Movie.changeset(%Movie{}, @invalid_attrs)
    refute changeset.valid?
  end
end
