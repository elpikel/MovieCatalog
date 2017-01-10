defmodule MovieCatalog.CommentTest do
  use MovieCatalog.ModelCase

  alias MovieCatalog.Comment

  @valid_attrs %{message: "some content", user_id: 1, movie_id: 2}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
