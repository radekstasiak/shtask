defmodule Shtask.TaskTypeTest do
  use Shtask.ModelCase
  import Shtask.Fixtures
  alias Shtask.TaskType

  @valid_attrs %{name: "support"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TaskType.changeset(%TaskType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TaskType.changeset(%TaskType{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "task type can be added to the db" do
    changeset = TaskType.changeset(%TaskType{}, @valid_attrs)
    assert {:ok, _inserted_task_type} = Shtask.Repo.insert(changeset)
  end

  test "task type name should be present" do
    attrs = %{@valid_attrs | name: ""}
    changeset = TaskType.changeset(%TaskType{}, attrs)
    refute changeset.valid?

    attrs = %{@valid_attrs | name: nil}
    changeset = TaskType.changeset(%TaskType{}, attrs)
    refute changeset.valid?

    attrs = Map.delete(@valid_attrs, :name)
    changeset = TaskType.changeset(%TaskType{}, attrs)
    refute changeset.valid?
  end

  test "task type name should be unique" do
    task_type = fixture(:task_type)
    attrs = %{@valid_attrs | name: String.upcase(task_type.name)}
    changeset = TaskType.changeset(%TaskType{}, attrs)
    assert {:error, _inserted_task_type} = Shtask.Repo.insert(changeset)
  end

  test "task type preload function" do
    task_type = fixture(:task_type)
    task_type_preload = TaskType.preload(task_type.id)

    assert task_type.id == task_type_preload.id
  end
end
