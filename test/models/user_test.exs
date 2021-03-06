defmodule Shtask.UserTest do
  use Shtask.ModelCase
  import Shtask.Fixtures
  alias Shtask.User

  @valid_attrs %{team_domain: "XY1", team_id: "vedar", user_id: "RS1", user_name: "Radek"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "user name should be present" do
    attrs = %{@valid_attrs | user_name: ""}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | user_name: nil}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :user_name)
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

  end

  test "user id should be present" do
    attrs = %{@valid_attrs | user_id: ""}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | user_id: nil}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :user_id)
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end

  test "user id should be unique" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, _inserted_user} = Shtask.Repo.insert(changeset)
    assert {:error, _changeset} = Shtask.Repo.insert(changeset)
  end

  test "team id should be present" do
    attrs = %{@valid_attrs | team_domain: ""}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | team_domain: nil}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :team_domain)
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end

  test "team domain should be present" do
    attrs = %{@valid_attrs | team_domain: ""}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | team_domain: nil}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :team_domain)
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end


  test "team id should not be unique" do
    user = fixture(:user)
    attrs = %{@valid_attrs | team_id: user.team_id}
    changeset = User.changeset(%User{}, attrs)
    assert {:ok, _inserted_user} = Shtask.Repo.insert(changeset)
  end


  test "user_id field is case insensitive" do
    user = fixture(:user)
    attrs = %{@valid_attrs | user_id: String.downcase(user.user_id)}
    changeset = User.changeset(%User{}, attrs)
    assert {:error, _changeset} = Shtask.Repo.insert(changeset)
  end

  test "user should have no tasks" do
    user = fixture(:user)
    #task = Task |> Shtask.Repo.get(task.id) |> Shtask.Repo.preload([:users])
    user = User.preload(user.id)
    length = Kernel.length(user.tasks)
    assert  length == 0
  end

  test "user should have a task" do
    user_task = fixture(:user_task)
    user = Shtask.User.preload(user_task.user_id)
    length = Kernel.length(user.tasks)
    assert  length == 1
  end

  test "user should have a UserTask" do
    user_task = fixture(:user_task)
    user = Shtask.User.preload(user_task.user_id)
    length = Kernel.length(user.user_tasks)
    assert length == 1
  end

end
